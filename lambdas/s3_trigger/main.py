import boto3
import csv
import os
import json
import traceback

dynamodb = boto3.resource('dynamodb')
sqs = boto3.client('sqs')
secretsmanager = boto3.client('secretsmanager')
s3 = boto3.client('s3')

SECRET_NAME = os.environ['SECRET_NAME']
QUEUE_URL = os.environ.get('QUEUE_URL')

def get_table_name():
    response = secretsmanager.get_secret_value(SecretId=SECRET_NAME)
    secret = json.loads(response['SecretString'])
    return secret['table_name']

def lambda_handler(event, context):
    print("Lambda triggered with event:", json.dumps(event))
    table_name = get_table_name()
    print("DynamoDB Table Name:", table_name)
    
    table = dynamodb.Table(table_name)

    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']
        print(f"Processing file: s3://{bucket}/{key}")

        obj = s3.get_object(Bucket=bucket, Key=key)
        csv_content = obj['Body'].read().decode('utf-8').splitlines()
        reader = csv.DictReader(csv_content)

        for row in reader:
            if 'PK' not in row or 'SK' not in row:
                print(f"Skipping row missing PK or SK: {row}")
                continue
            item = {k: v for k, v in row.items() if v is not None}
            table.put_item(Item=item)

        # Send message to SQS
        message = {"bucket": bucket, "key": key}
        if QUEUE_URL:
            try:
                sqs.send_message(
                    QueueUrl=QUEUE_URL,
                    MessageBody=json.dumps(message),
                    DelaySeconds=120
                )
                print("Message sent to SQS.")
            except Exception as e:
                print("Failed to send message to SQS:", str(e))
                traceback.print_exc()
        else:
            print("QUEUE_URL not set. Message not sent.")

    return {
        "statusCode": 200,
        "body": json.dumps("CSV processed, inserted into DynamoDB, and message sent to SQS.")
    }
