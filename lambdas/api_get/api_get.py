import json
import boto3
import os
import uuid
from boto3.dynamodb.conditions import Key
from decimal_encoder import DecimalEncoder

def lambda_handler(event, context):
    try:   
        print('Incoming event: ', event)

        dynamo_table = os.environ['DYNAMO_TABLE_NAME']
        dynamodb = boto3.resource('dynamodb')
        table = dynamodb.Table(dynamo_table)

        if event['queryStringParameters']:
            area_name = event['queryStringParameters']['area_name']
            print(area_name)
        
            response = table.query(
                KeyConditionExpression=Key('area_name').eq(area_name)
            )

            print(response['Items'])

            return {
                'statusCode': 200,
                'headers': {'content-type': 'application/json'},
                'body': json.dumps(response['Items'], cls=DecimalEncoder)
            }
        else:
            return {
                'statusCode': 404,
                'headers': {'content-type': 'application/json'},
                'body': json.dumps({"msg": f"area data with key: {event['queryStringParameters']['area_name']} hasn't been found"})
            }
    except Exception as e:
        print(e)
        return {
            'statusCode': 500,
            'headers': {'content-type': 'application/json'},
            'body': json.dumps(e)
        }

