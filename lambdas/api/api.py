import json
import boto3
import os
import uuid

def lambda_handler(event, context):
    try:
        
        client = boto3.client('kinesis')

        print('Incoming event: ', event)
    
        user_data = event['body']
        k_response = client.put_record(
            StreamName = os.environ['KINESIS_STREAM_NAME'],
            Data = user_data,
            PartitionKey = str(uuid.uuid4())
        )
        
        print(k_response)

        return {
            'statusCode': 200,
            'headers': {'content-type': 'application/json'},
            'body': json.dumps({'shard': k_response['ShardId']})
        }

    except Exception as e:
        print(e)
        return {
            'statusCode': 500,
            'headers': {'content-type': 'application/json'},
            'body': json.dumps(e)
        }

