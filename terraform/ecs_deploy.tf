provider "aws" {
  region = "us-east-1"
}

# ECS Cluster
resource "aws_ecs_cluster" "mlops_cluster" {
  name = "MLOpsCluster"
}

# ECS Task Definition
resource "aws_ecs_task_definition" "mlops_task" {
  family                   = "MLOpsInferenceTask"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "mlops-container",
      "image": "your-docker-image",  # Replace with your Docker image path
      "memory": 512,
      "cpu": 256,
      "essential": true,
      "portMappings": [
        {
          "containerPort": 5000,
          "hostPort": 5000
        }
      ]
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
}

# ECS Service
resource "aws_ecs_service" "mlops_service" {
  name            = "MLOpsInferenceService"
  cluster         = aws_ecs_cluster.mlops_cluster.id
  task_definition = aws_ecs_task_definition.mlops_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  
  network_configuration {
    subnets          = [aws_subnet.main.id]
    security_groups  = [aws_security_group.main.id]
    assign_public_ip = true
  }
}