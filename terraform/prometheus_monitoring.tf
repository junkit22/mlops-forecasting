provider "aws" {
  region = "us-east-1"
}

# EC2 instance for Prometheus
resource "aws_instance" "prometheus" {
  ami           = "ami-0c55b159cbfafe1f0"  # Select the appropriate AMI
  instance_type = "t2.micro"
  tags = {
    Name = "MLOpsPrometheus"
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo apt-get update -y
                sudo apt-get install -y prometheus
                sudo systemctl start prometheus
                sudo systemctl enable prometheus
              EOF

  key_name      = "your-key-pair"  # Replace with your key pair
  subnet_id     = aws_subnet.main.id
  security_groups = [aws_security_group.main.id]
}

# Security group for Prometheus
resource "aws_security_group" "prometheus_sg" {
  name        = "prometheus_sg"
  description = "Allow Prometheus traffic"
  
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}