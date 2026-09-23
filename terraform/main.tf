resource "aws_security_group" "ai_todo_list" {
  name        = "ai-todo-list-security-group"
  description = "Security group for AI To-Do List web server"
  vpc_id      = "vpc-07bbb32be8712a737"

  ingress {
    description = "SSH from my current IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["90.130.52.47/32"]
  }

  ingress {
    description = "HTTP from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ai-todo-list-security-group"
  }
}

output "security_group_id" {
  value = aws_security_group.ai_todo_list.id
}

resource "aws_instance" "ai_todo_list" {
  ami           = "ami-0c4fc5dcabc9df21d"
  instance_type = "t3.micro"
  credit_specification {
    cpu_credits = "standard"
  }

  subnet_id              = "subnet-02c6b8bce6119ebc7"
  vpc_security_group_ids = [aws_security_group.ai_todo_list.id]
  key_name               = "devops.school.level3.tabish-admin"

  associate_public_ip_address = true

  user_data = <<-EOF2
    #!/bin/bash

    dnf install -y nginx python3 python3-pip

    systemctl enable nginx
    systemctl start nginx

    mkdir -p /opt/ai-todo-list/backend
    mkdir -p /var/www/ai-todo-list

    chown -R ec2-user:ec2-user /opt/ai-todo-list
    chown -R ec2-user:ec2-user /var/www/ai-todo-list
  EOF2

  user_data_replace_on_change = true

  tags = {
    Name = "ai-todo-list"
  }
}

output "instance_id" {
  value = aws_instance.ai_todo_list.id
}

output "public_ip" {
  value = aws_instance.ai_todo_list.public_ip
}

output "public_dns" {
  value = aws_instance.ai_todo_list.public_dns
}
