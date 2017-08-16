#!/usr/bin/env python

import boto3

#CONNECT TO DMS VIA BOTO3 CLIENT
client = boto3.client('dms')

response = client.create_replication_task(
    ReplicationTaskIdentifier='dr-who-migration',
    SourceEndpointArn='arn:aws:dms:us-east-1:687720138916:endpoint:T2LA4RF4ULC44N3RR2PFTMRZCY',
    TargetEndpointArn='arn:aws:dms:us-east-1:687720138916:endpoint:MOAITORVFW3E62MS4A2QXAGVYA',
    ReplicationInstanceArn='arn:aws:dms:us-east-1:687720138916:rep:MT3SNM4BY5U4KAEOH4XUZEO4ME',
    MigrationType='full-load',
    TableMappings='file://DMS_TABLEMAPPINGS.json',
    ReplicationTaskSettings='file://DMS_TASKSETTINGS.json'
)