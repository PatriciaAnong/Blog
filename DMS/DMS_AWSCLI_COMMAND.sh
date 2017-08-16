#CREATE TASK
aws dms create-replication-task 
  --replication-task-identifier dr-who-migration 
  --source-endpoint-arn arn:aws:dms:us-east-1:1111111111111:endpoint:DOCTORWHOISAWOMAN01 
  --target-endpoint-arn arn:aws:dms:us-east-1:111111111111:endpoint:YUPSHESUREIS02WOWZERS 
  --replication-instance-arn arn:aws:dms:us-east-1:111111111111:rep:SOCRAZYTHATDOCTORWHOSIAWOMAN03 
  --migration-type full-load 
  --table-mappings file:////home/panong/DMS_TABLEMAPPINGS.json 
  --replication-task-settings file:////home/panong/DMS_TASKSETTINGS.json

  
#START TASK
aws dms start-replication-task 
  --replication-task-arn arn:aws:dms:us-east-1:1111111111111:task:YUPYOUJUSTSTARTEDTHEDRWHOTASK 
  --start-replication-task-type start-replication