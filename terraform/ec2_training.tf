provider "aws" {
  region = "us-east-1"  # Change to your desired region
}

resource "aws_instance" "ml_training" {
  ami           = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI (Update this based on the latest AMI in your region)
  instance_type = "t2.micro"  # Change to your preferred instance type
  key_name      = "your-key-pair"  # Change to your EC2 key pair name
  
  # Security Group
  vpc_security_group_ids = [aws_security_group.ml_training_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              # Update the system and install required packages
              sudo yum update -y
              sudo yum install -y python3 git
              sudo pip3 install --upgrade pip
              # Clone your repository (or copy your files to the instance)
              git clone https://github.com/your_username/mlops-forecasting.git /home/ec2-user/mlops-forecasting
              # Install the requirements
              pip3 install -r /home/ec2-user/mlops-forecasting/requirements.txt
              # Run the training script
              python3 /home/ec2-user/mlops-forecasting/src/train.py
            EOF

  tags = {
    Name = "MLTrainingInstance"
  }
}

resource "aws_security_group" "ml_training_sg" {
  name        = "ml_training_sg"
  description = "Allow SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Change this to your specific IP for better security
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Change this to your specific IP for better security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}