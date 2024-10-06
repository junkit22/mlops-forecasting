provider "aws" {
  region = "us-east-1"
}

# S3 bucket for storing models
resource "aws_s3_bucket" "mlops_bucket" {
  bucket = "mlops-forecasting-bucket"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name = "mlops-forecasting-bucket"
  }
}

# IAM Role for SageMaker Execution
resource "aws_iam_role" "sagemaker_execution_role" {
  name = "SageMakerExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "SageMakerExecutionRole"
  }
}

# Attach necessary policies to the role
resource "aws_iam_role_policy_attachment" "sagemaker_s3_policy" {
  role       = aws_iam_role.sagemaker_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "sagemaker_execution_policy" {
  role       = aws_iam_role.sagemaker_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

# SageMaker Endpoint Configuration
resource "aws_sagemaker_model" "ml_model" {
  name           = "mlops-forecasting-model"
  execution_role_arn = aws_iam_role.sagemaker_execution_role.arn

  primary_container {
    image          = "683313688378.dkr.ecr.us-east-1.amazonaws.com/sagemaker-scikit-learn:0.23-1-cpu-py3"
    model_data_url = "s3://${aws_s3_bucket.mlops_bucket.bucket}/models/model.joblib"
  }
}

resource "aws_sagemaker_endpoint_configuration" "endpoint_config" {
  name = "mlops-endpoint-config"

  production_variants {
    variant_name          = "AllTraffic"
    model_name            = aws_sagemaker_model.ml_model.name
    initial_instance_count = 1
    instance_type          = "ml.m5.large"
  }
}

resource "aws_sagemaker_endpoint" "ml_endpoint" {
  endpoint_name = "mlops-endpoint"
  endpoint_config_name = aws_sagemaker_endpoint_configuration.endpoint_config.name
}