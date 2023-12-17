terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "s_keys" {
  key_name   = "s_keys"
  public_key = file("~/keys/s_key.pub")
}

resource "aws_instance" "app_server" {
  ami           = "ami-06aa3f7caf3a30282"
  instance_type = "t2.micro"

  tags = {
    Name = "Server1"
  }

  key_name = aws_key_pair.s_keys.key_name

  user_data = <<-EOF
              #!/bin/bash
              echo "${aws_key_pair.s_keys.public_key}" >> /home/ubuntu/.ssh/authorized_keys
              EOF

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y apache2",
      "sudo systemctl start apache2",
      "sudo systemctl enable apache2",
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"  
    private_key = file("~/keys/s_key") 
    host = self.public_ip
    timeout     = "2m"
  }
}

resource "aws_security_group" "app_server_sg2" {
  name = "app_server_sg2"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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

