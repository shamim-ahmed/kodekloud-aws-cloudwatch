import boto3
import random
import time
import decimal
from botocore.exceptions import ClientError

dynamodb = boto3.resource('dynamodb', region_name='ap-southeast-2')
table_name = 'ShoppingData'

# Create DynamoDB table if it does not exist
def create_table():
    try:
        table = dynamodb.create_table(
            TableName=table_name,
            KeySchema=[
                {
                    'AttributeName': 'order_id',
                    'KeyType': 'HASH'
                },
            ],
            AttributeDefinitions=[
                {
                    'AttributeName': 'order_id',
                    'AttributeType': 'S'
                },
            ],
            ProvisionedThroughput={
                'ReadCapacityUnits': 5,
                'WriteCapacityUnits': 5
            }
        )
        print(f"Table {table_name} created successfully.")
        table.wait_until_exists()
    except ClientError as e:
        if e.response['Error']['Code'] == 'ResourceInUseException':
            print(f"Table {table_name} already exists.")
        else:
            print("Unexpected error: %s" % e)

def put_random_shopping_data():
    table = dynamodb.Table(table_name)
    counter = 0
    while True:
        order_id = f"order_{random.randint(1, 10000)}"
        item_name = f"item_{random.randint(1, 100)}"
        quantity = random.randint(1, 20)
        price = decimal.Decimal(str(round(random.uniform(1, 1000), 2)))
        response = table.put_item(
           Item={
                'order_id': order_id,
                'item_name': item_name,
                'quantity': quantity,
                'price': price
            }
        )
        print(f"PutItem succeeded: {order_id}, {item_name}, {quantity}, {price}")
        counter += 1
        if counter % 100 == 0:
            print("Sleeping for 1 minute...")
            time.sleep(60)

if __name__ == '__main__':
    create_table()
    put_random_shopping_data()
