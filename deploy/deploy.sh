#!/bin/sh

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd $dir/../terraform

app_url=$(terraform output cloud_front_domain)
db_url=$(terraform output rds_db)

cd ../deploy

# Deploy backend
./be-deploy.sh

# Deploy frontend
./fe-deploy.sh

tput setaf 3
echo "DB endpoint: $db_url"
echo "Your application has been deployed here: $app_url"