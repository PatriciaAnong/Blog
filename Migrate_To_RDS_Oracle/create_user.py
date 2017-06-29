#!/usr/bin/env python
import boto3
import pprint

from botocore.exceptions import ClientError

pp = pprint.PrettyPrinter(indent=4)

#CONNECT TO IAM VIA BOTO3 CLIENT
client = boto3.client('iam')

list_users = client.get_user()

try:
        #CREATE USER
        user = client.create_user(UserName='bb8')
        #ADD USER TO GROUP:
        group = client.add_user_to_group(
        GroupName='Droids',
        UserName='bb8'
        )
        #CREATE ACCESS KEY
        keys = client.create_access_key(UserName='bb8')
        pp.pprint(keys)
        pp.pprint(list_users)
except ClientError as e:
        pp.pprint(e)
