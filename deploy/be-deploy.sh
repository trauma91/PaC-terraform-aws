#!/bin/sh
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

. ./setEnv.sh

cd $dir/../terraform

ecr_repository=$(terraform output ecr_repo)
cluster_name=$(terraform output cluster_name)
service_name=$(terraform output service_name)

cd ../backend

# Build the docker image and push it to the ECR repository
aws ecr get-login-password --region $aws_region |
sudo docker login --username AWS --password-stdin $aws_account_id.dkr.ecr.eu-west-1.amazonaws.com

sudo docker build -t $ecr_repository .

sudo docker tag $ecr_repository:latest $ecr_repository:latest

sudo docker push $ecr_repository:latest

# Update service definition forcing a new deployment
aws ecs update-service --cluster $cluster_name --service $service_name