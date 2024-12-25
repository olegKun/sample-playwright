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

variable "ansible_trigger" {
  description = "A trigger to indicate when Ansible has completed the Docker installation"
  type        = string
  default     = "" # Optional: Set a default value (can be empty initially)
}

resource "null_resource" "move_docker_override" {
  depends_on = [aws_instance.jenkins]
  # triggers = {
  #   ansible_completed = var.ansible_trigger == "docker_installed" ? "true" : "false"
  # }

  count = var.ansible_trigger == "docker_installed" ? 1 : 0


  provisioner "file" {
    # source      = "${path.module}/overrides/docker.service.override.tpl"
    destination = "/tmp/docker.service.override"
    content     = templatefile("${path.module}/overrides/docker.service.override.tpl", {
      PRIVATE_IP = aws_instance.jenkins.private_ip
    })
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /etc/systemd/system/docker.service.d",
      "sudo mv /tmp/docker.service.override /etc/systemd/system/docker.service.d/override.conf",
      "sudo systemctl daemon-reload",
      "sudo systemctl restart docker"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/oleg-ec2-key-pair.pem")
    host        = aws_instance.jenkins.public_ip
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

  depends_on = [aws_instance.jenkins]
}

output "jenkins_url" {
  value = "http://${aws_instance.jenkins.public_ip}:8080"
}

output "private_ip" {
  value = "${aws_instance.jenkins.private_ip}"
}