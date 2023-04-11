import json
import boto3
import datetime
import json
from datetime import date
from csv import DictWriter
import csv
from pathlib import Path

sqs = boto3.client('sqs',  
aws_access_key_id='xxxxxx',
aws_secret_access_key='xxxxx', 
region_name='us-east-1',
)

sendQueueUrl='https://xxxx'
response = sqs.receive_message(QueueUrl=sendQueueUrl, MaxNumberOfMessages=10, MessageAttributeNames=['ReceiptHandle'],
                                    WaitTimeSeconds=20)

messageid = (response['Messages'][0]['MessageId'])

receipthandle = (response['Messages'][0]['ReceiptHandle'])

message = json.loads(response['Messages'][0]['Body'])

shit = json.loads(message['Message'])

a = shit['bounce']
b = shit['mail']
c = shit['mail']['headers'][0]['value']
d = shit['mail']['headers']


timestamp = (a['timestamp'])

bounced_email = a['bouncedRecipients'][0]['emailAddress']

# error code provided by destination mail server
diag_code = a['bouncedRecipients'][0]['diagnosticCode']

FILE_PATH = Path('/home/xxxxx/rejected.csv')

if not FILE_PATH.exists():
    with open(FILE_PATH, 'w', newline='') as order_csv:
        order_csv_write = csv.writer(order_csv)
        order_csv_write.writerow(
            ["EMAIL", "TIMESTAMP", "DIAG_CODE", "REASON"])

# this is for csv file 
with open(FILE_PATH, 'a', newline='') as order_csv:

    import re
    pattern = 'Subject'
    for i in d: 
        if pattern in i['name']: 
            #print(i['value'])
            order_csv_append = csv.writer(order_csv)
            order_csv_append.writerow([bounced_email, diag_code, i['value']])
            print(bounced_email, timestamp,  diag_code, i['value'])

            with open('/home/rod_simioni/output.txt', 'a') as f:
                f.write(bounced_email + '\n')



