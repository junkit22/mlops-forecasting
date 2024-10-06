# CloudWatch Log Group for SageMaker endpoint logs
resource "aws_cloudwatch_log_group" "sagemaker_logs" {
  name              = "/aws/sagemaker/mlops-endpoint-logs"
  retention_in_days = 30
}

# CloudWatch Alarms for monitoring the SageMaker endpoint
resource "aws_cloudwatch_metric_alarm" "model_inference_time_alarm" {
  alarm_name          = "HighInferenceLatency"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ModelLatency"
  namespace           = "AWS/SageMaker"
  period              = 60
  statistic           = "Average"
  threshold           = 1000  # 1 second
  alarm_description   = "Alarm when inference latency exceeds 1 second"
  actions_enabled     = true

  dimensions = {
    EndpointName = "mlops-endpoint"
  }

  alarm_actions = [
    "arn:aws:sns:us-east-1:123456789012:your-sns-topic"
  ]
}

# Drift Detection with CloudWatch
resource "aws_cloudwatch_metric_alarm" "model_drift_alarm" {
  alarm_name          = "ModelDriftDetected"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ModelDrift"
  namespace           = "AWS/SageMaker"
  period              = 60
  statistic           = "Sum"
  threshold           = 1  # Trigger if drift is detected
  alarm_description   = "Alarm when data drift is detected"
  actions_enabled     = true

  dimensions = {
    EndpointName = "mlops-endpoint"
  }

  alarm_actions = [
    "arn:aws:sns:us-east-1:123456789012:your-sns-topic"
  ]
}