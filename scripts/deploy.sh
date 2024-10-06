#!/bin/bash

# Variables
AWS_ACCOUNT_ID=<your_aws_account_id>  # Replace with your AWS account ID
REGION=us-east-1                        # Change to your preferred region
ECR_REPO_NAME=mlops-forecasting-repo         # Replace with your ECR repository name
IMAGE_TAG=latest                        # Tag for the Docker image
ECS_CLUSTER_NAME=mlops-forecasting-cluster       # Replace with your ECS cluster name
ECS_SERVICE_NAME=mlops-forecasting-service       # Replace with your ECS service name
ECS_TASK_DEFINITION=your-task-def      # Replace with your task definition name

# Docker Build and Push
echo "Building Docker image..."
docker build -t $ECR_REPO_NAME .

# Authenticate Docker to your ECR
echo "Logging in to Amazon ECR..."
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# Tag and push the Docker image to ECR
echo "Tagging Docker image..."
docker tag $ECR_REPO_NAME:latest $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$ECR_REPO_NAME:$IMAGE_TAG
echo "Pushing Docker image to ECR..."
docker push $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$ECR_REPO_NAME:$IMAGE_TAG

# Apply Terraform for ECS and Prometheus
cd terraform
echo "Initializing Terraform..."
terraform init
echo "Applying Terraform configuration..."
terraform apply -auto-approve

# Output ECS Service URL
ECS_SERVICE_URL=$(aws ecs describe-services --cluster $ECS_CLUSTER_NAME --services $ECS_SERVICE_NAME --query "services[0].loadBalancers[0].dnsName" --output text)

echo "ECS Service URL: http://$ECS_SERVICE_URL"

# Setup Prometheus Monitoring
echo "Setting up Prometheus monitoring..."
# Here you may include any specific steps required to configure Prometheus, 
# such as modifying configuration files or deploying Prometheus to the ECS cluster.

echo "Deployment completed successfully."