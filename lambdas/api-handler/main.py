import json
import boto3
import base64
import os
import uuid

s3 = boto3.client('s3')
dynamodb = boto3.resource('dynamodb')
secretsmanager = boto3.client('secretsmanager')

BUCKET_NAME = os.environ['BUCKET_NAME']
SECRET_NAME = os.environ['SECRET_NAME']

def get_table_name():
    response = secretsmanager.get_secret_value(SecretId=SECRET_NAME)
    secret = json.loads(response['SecretString'])
    return secret['table_name']

def lambda_handler(event, context):
    method = event['httpMethod']
    
    if method == 'POST':
        return handle_post(event)
    elif method == 'GET':
        return handle_get(event)
    else:
        return {
            "statusCode": 400,
            "body": json.dumps({"message": "Unsupported method"})
        }

def handle_post(event):
    body = event['body']
    is_base64_encoded = event.get('isBase64Encoded', False)
    
    if is_base64_encoded:
        file_content = base64.b64decode(body)
    else:
        file_content = body.encode('utf-8')
    
    file_key = f"uploads/{uuid.uuid4()}.csv"
    s3.put_object(Bucket=BUCKET_NAME, Key=file_key, Body=file_content)

    return {
        "statusCode": 200,
        "body": json.dumps({"message": "File uploaded successfully", "file_key": file_key})
    }

def handle_get(event):
    params = event.get('queryStringParameters', {})
    pk = params.get('PK')
    sk = params.get('SK')

    if not pk or not sk:
        return {
            "statusCode": 400,
            "body": json.dumps({"message": "Missing PK or SK in query parameters"})
        }
    
    table_name = get_table_name()
    table = dynamodb.Table(table_name)
    
    try:
        response = table.get_item(Key={'PK': pk, 'SK': sk})
        item = response.get('Item', {})
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"message": str(e)})
        }

    return {
        "statusCode": 200,
        "body": json.dumps(item)
    }
