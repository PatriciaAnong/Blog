#!/bin/bash

export EMAIL=patriciaanong@gmail.com
export CIRCLE=PAnong_Inspec_Blog
export API_KEY=`cat /run/secrets/heimdall_key`

# Run Inspec Profiles

inspec exec . -t gcp:// --input-file attributes.yml --reporter json:/src/gcp-inspec-instance-results.json || true
inspec_tools compliance -j /src/gcp-inspec-instance-results.json -f threshold.yml
inspec_tools summary -j /src/gcp-inspec-instance-results.json -o /src/gcp-summary.json -c

# CIS Docker Baseline
cd ../docker
inspec exec . -i ~/.ssh/google_compute_engine -t ssh://root@34.73.144.37 --reporter json:/src/docker-inspec-instance-results.json --input-file attributes.yml
inspec_tools compliance -j /src/docker-inspec-instance-results.json -f threshold.yml
inspec_tools summary -j /src/docker-inspec-instance-results.json -o /src/docker-summary.json -c

# Linux Baseline
cd ../linux
inspec exec . -i ~/.ssh/google_compute_engine -t ssh://root@34.73.144.37 --reporter json:/src/linux-inspec-instance-results.json || true
inspec_tools compliance -j /src/linux-inspec-instance-results.json -f threshold.yml
inspec_tools summary -j /src/linux-inspec-instance-results.json -o /src/linux-summary.json -c

# SSH Baseline
cd ../ssh
inspec exec . -i ~/.ssh/google_compute_engine -t ssh://root@34.73.144.37 --reporter json:/src/ssh-inspec-instance-results.json || true
inspec_tools compliance -j /src/ssh-inspec-instance-results.json -f threshold.yml
inspec_tools summary -j /src/ssh-inspec-instance-results.json -o /src/ssh-summary.json -c

# Push evaluations to Heimdall
curl -F "file=@/src/gcp-inspec-instance-results.json" -F "email=$EMAIL" -F "api_key=$API_KEY" -F "circle=$CIRCLE" heimdall_server:3000/evaluation_upload_api

curl -F "file=@/src/docker-inspec-instance-results.json" -F "email=$EMAIL" -F "api_key=$API_KEY" -F "circle=$CIRCLE" heimdall_server:3000/evaluation_upload_api

curl -F "file=@/src/linux-inspec-instance-results.json" -F "email=$EMAIL" -F "api_key=$API_KEY" -F "circle=$CIRCLE" heimdall_server:3000/evaluation_upload_api

curl -F "file=@/src/ssh-inspec-instance-results.json" -F "email=$EMAIL" -F "api_key=$API_KEY" -F "circle=$CIRCLE" heimdall_server:3000/evaluation_upload_api