import boto3
import json
import os

s3 = boto3.client('s3')

BUCKET_NAME = os.environ['BUCKET_NAME']

def lambda_handler(event, context):
    for record in event['Records']:
        message = json.loads(record['body'])
        bucket = message['bucket']
        key = message['key']

        try:
            s3.delete_object(Bucket=bucket, Key=key)
            print(f"Deleted {key} from {bucket}")
        except Exception as e:
            print(f"Error deleting {key}: {str(e)}")
    
    return {
        "statusCode": 200,
        "body": json.dumps("Files deleted successfully")
    }
