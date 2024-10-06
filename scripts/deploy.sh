#!/bin/bash

# Constants
S3_BUCKET="mlops-forecasting-bucket"
MODEL_ARTIFACT="models/model.joblib"
SAGEMAKER_ROLE_ARN="arn:aws:iam::123456789012:role/SageMakerExecutionRole"  # Replace with your SageMaker execution role ARN
SAGEMAKER_MODEL_NAME="mlops-forecasting-model"
SAGEMAKER_ENDPOINT_CONFIG_NAME="mlops-endpoint-config"
SAGEMAKER_ENDPOINT_NAME="mlops-endpoint"

# Step 1: Upload Model Artifact to S3
echo "Uploading model artifact to S3..."
aws s3 cp $MODEL_ARTIFACT s3://$S3_BUCKET/$MODEL_ARTIFACT

# Step 2: Create SageMaker Model
echo "Creating SageMaker model..."
aws sagemaker create-model \
    --model-name $SAGEMAKER_MODEL_NAME \
    --primary-container Image="683313688378.dkr.ecr.us-east-1.amazonaws.com/sagemaker-scikit-learn:0.23-1-cpu-py3",ModelDataUrl="s3://$S3_BUCKET/$MODEL_ARTIFACT" \
    --execution-role-arn $SAGEMAKER_ROLE_ARN

# Step 3: Create Endpoint Configuration
echo "Creating endpoint configuration..."
aws sagemaker create-endpoint-config \
    --endpoint-config-name $SAGEMAKER_ENDPOINT_CONFIG_NAME \
    --production-variants VariantName=AllTraffic,ModelName=$SAGEMAKER_MODEL_NAME,InitialInstanceCount=1,InstanceType=ml.m5.large

# Step 4: Deploy the Model
echo "Deploying model to SageMaker endpoint..."
aws sagemaker create-endpoint \
    --endpoint-name $SAGEMAKER_ENDPOINT_NAME \
    --endpoint-config-name $SAGEMAKER_ENDPOINT_CONFIG_NAME

echo "Deployment successful. SageMaker endpoint: $SAGEMAKER_ENDPOINT_NAME"
