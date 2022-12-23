import boto3
from aws_kinesis_agg.deaggregator import deaggregate_records
from location_calculator import LocationCalculator
from decimal import Decimal
import base64
import json
from region import Region
import os

# this data is static and aclually will never change, only extends
spain_regions_polygon = [
    Region("Malaga",37.83705483588691,-3.62491569589503),
    Region("Barcelona", 40.71097853364055, -0.21915397714503015)
]


def generate_table_items(event) -> list:
    items = []

    area_dict = { region.name : region for region in spain_regions_polygon }
    for area in event["state"]:
        region_data = area_dict[area]
        items.append({
            'area_name': area,
            'window_end': event["window"]["start"],
            'window_start': event["window"]["end"],
            'lon': region_data.lon,
            'lat': region_data.lat,
            'points': event["state"][area]
        })
        
    return items


def lambda_handler(event, context):
    calculator = LocationCalculator(regions=spain_regions_polygon, radius_km=100)

    records = event['Records']

    
    print('Incoming event: ', event)

    state = event['state']  

    if event['isFinalInvokeForWindow']:
        dynamo_table = os.environ['DYNAMO_TABLE_NAME']
        dynamodb = boto3.resource('dynamodb')
        table = dynamodb.Table(dynamo_table)

        region_items = generate_table_items(event)
        with table.batch_writer() as batch:
            for item in region_items:
                batch.put_item(
                    Item=json.loads(json.dumps(item), parse_float=Decimal)
            )

    user_records = deaggregate_records(records)
    for record in user_records:
        payload=base64.b64decode(record["kinesis"]["data"]).decode("UTF-8")
        formattedPayload = json.loads(payload)
        if "user_id" in formattedPayload:
            region_name = calculator.find_region_name(formattedPayload['loc_x'], formattedPayload['loc_y'])
            if region_name:
                if region_name not in state:
                    state[region_name] = 1
                else:
                    state[region_name] += 1

    print('Out state: ', state)

    return {'state': state}
