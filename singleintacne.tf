provider "aws" {
  region = "us-east-1" # Change this to your desired region
}

resource "aws_instance" "example" {
  ami           = "ami-0123456789abcdef0" # Replace with your desired AMI ID
  instance_type = "t2.micro"              # Change to your desired instance type
  key_name      = "your-key-pair-name"    # Change to your key pair name

  user_data = <<-EOF
              #!/bin/bash
              # Your user data script here
              # For example, you can install software or configure settings
              echo "Hello, World!" > /tmp/hello.txt
              EOF
}

resource "aws_network_interface_sg_attachment" "example" {
  security_group_ids    = [aws_security_group.example.id]
  network_interface_id = aws_instance.example.network_interface_ids[0]
}

resource "aws_security_group" "example" {
  name_prefix = "example-"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_network_interface_sg_attachment" "example" {
  security_group_ids    = [aws_security_group.example.id]
  network_interface_id = aws_instance.example.network_interface_ids[0]
}

resource "aws_network_interface_sg_attachment" "example" {
  security_group_ids    = [aws_security_group.example.id]
  network_interface_id = aws_instance.example.network_interface_ids[0]
}

resource "aws_network_interface_sg_attachment" "example" {
  security_group_ids    = [aws_security_group.example.id]
  network_interface_id = aws_instance.example.network_interface_ids[0]
}

resource "aws_network_interface_sg_attachment" "example" {
  security_group_ids    = [aws_security_group.example.id]
  network_interface_id = aws_instance.example.network_interface_ids[0]
}

resource "aws_network_interface_sg_attachment" "example" {
  security_group_ids    = [aws_security_group.example.id]
  network_interface_id = aws_instance.example.network_interface_ids[0]
}

resource "aws_network_interface_sg_attachment" "example" {
  security_group_ids    = [aws_security_group.example.id]
  network_interface_id = aws_instance.example.network_interface_ids[0]
}

resource "aws_network_interface_sg_attachment" "example" {
  security_group_ids    = [aws_security_group.example.id]
  network_interface_id = aws_instance.example.network_interface_ids[0]
}

resource "aws_network_interface_sg_attachment" "example" {
  security_group_ids    = [aws_security_group.example.id]
  network_interface_id = aws_instance.example.network_interface_ids[0]
}
resource "aws_network_interface_sg_attachment" "example" {
  security_group_ids    = [aws_security_group.example.id]
  network_interface_id = aws_instance.example.network_interface_ids[0]
}
resource "aws_network_interface_sg_attachment" "example" {
  security_group_ids    = [aws_security_group.example.id]
  network_interface_id = aws_instance.example.network_interface_ids[0]
}
resource "aws_network_interface_sg_attachment" "example" {
  security_group_ids    = [aws_security_group.example.id]
  network_interface_id = aws_instance.example.network_interface_ids[0]
}
resource "aws_network_interface_sg_attachment" "example" {
  security_group_ids    = [aws_security_group.example.id]
  network_interface_id = aws_instance.example.network_interface_ids[0]
}

resource "aws_network_interface_sg_attachment" "example" {
  security_group_ids    = [aws_security_group.example.id]
  network_interface_id = aws_instance.example.network_interface_ids[0]
}

resource "aws_network_interface_sg_attachment" "example" {
  security_group_ids    = [aws_security_group.example.id]
  network_interface_id = aws_instance.example.network_interface_ids[0]
}

resource "aws_network_interface_sg_attachment" "example" {
  security_group_ids    = [aws_security_group.example.id]
  network_interface_id = aws_instance.example.network_interface_ids[0]
}

resource "aws_network_interface_sg_attachment" "example" {
  security_group_ids    = [aws_security_group.example.id]
  network_interface_id = aws_instance.example.network_interface_ids[0]
}

resource "aws_network_interface_sg_attachment" "example" {
  security_group_ids    = [aws_security_group.example.id]
  network_interface_id = aws_instance.example.network_interface_ids[0]
}

resource "aws_network_interface_sg_attachment" "example" {
  security_group_ids    = [aws_security_group.example.id]
  network_interface_id = aws_instance.example.network_interface_ids[0]
}

resource "aws_network_interface_sg_attachment" "example" {
  security_group_ids    = [aws_security_group.example.id]
  network_interface_id = aws_instance.example.network_interface_ids[0]
}

resource "aws_network_interface_sg_attachment" "example" {
  security_group_ids    = [aws_security_group.example.id]
  network_interface_id = aws_instance.example.network_interface_ids[0]
}

resource "aws_network_interface_sg_attachment" "example" {
  security_group_ids    = [aws_security_group.example.id]
  network_interface_id = aws_instance.example.network_interface_ids[0]
}

resource "aws_network_interface_sg_attachment" "example" {
  security_group_ids    = [aws_security_group.example.id]
  network_interface_id = aws_instance.example.network_interface_ids[0]
}

resource "aws_network_interface_sg_attachment" "example" {
  security_group_ids    = [aws_security_group.example.id]
  network_interface_id = aws_instance.example.network_interface_ids[0]
}
