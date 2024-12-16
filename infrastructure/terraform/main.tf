provider "aws" {
  region = "eu-central-1" # Update as needed
}

resource "aws_instance" "jenkins" {
  ami           = "ami-0b5673b5f6e8f7fa7" # Amazon Linux 2023 AMI for eu-central-1
  instance_type = "t2.micro"

  key_name = "oleg-ec2-key-pair" # Replace with your key pair name
  security_groups = [aws_security_group.jenkins_sg.name]

  tags = {
    Name = "Jenkins-Server"
  }
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Allow Jenkins and SSH access"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust for security
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust for security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../jenkins/inventory.ini"
  content  = <<-EOT
  [jenkins_server]
  ${aws_instance.jenkins.public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/oleg-ec2-key-pair.pem
  EOT
}

output "jenkins_url" {
  value = "http://${aws_instance.jenkins.public_ip}:8080"
}
