#!/bin/sh

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd $dir/../terraform

api_url=$(terraform output lb_dns)
s3_bucket_name=$(terraform output s3_bucket)

cd ../frontend

# Set the api url from the angular app, getting the lb dns name created via Terraform script
# The url is set into the test environement configuration
sed -i -E "s/(apiUrl: )[^>]+/\1\"http:\/\/$api_url\"/g" ./src/environments/environment.test.ts

npm install
# Build the application usig test configuration
ng build --configuration test

# Push statics to the s3 bucket
aws s3 sync ./dist/empamini s3://$s3_bucket_name