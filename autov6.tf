  provider "aws" {
  region = "us-west-1"  # Change this to your desired region
}

resource "aws_launch_template" "example" {
  name_prefix = "example-"

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 30
      volume_type = "gp2"
    }
  }

  network_interfaces {
    device_index              = 0
    associate_public_ip_address = true
    security_groups           = [aws_security_group.instance.id]
    subnet_id                 = aws_subnet.public.id
  }

  network_interfaces {
    device_index              = 1
    associate_public_ip_address = true
    security_groups           = [aws_security_group.instance.id]
    subnet_id                 = aws_subnet.public.id
  }

  instance_type = "t2.micro"
  image_id      = "ami-12345678"  # Replace with the Ubuntu AMI ID
  key_name      = "your-key-pair-name"
}

resource "aws_security_group" "instance" {
  name_prefix = "instance-"

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

resource "aws_subnet" "public" {
  cidr_block        = "10.0.1.0/24"  # Change this to your desired subnet CIDR block
  availability_zone = "us-west-1a"  # Change this to your desired availability zone
}

resource "aws_autoscaling_group" "example" {
  name_prefix = "example-"
  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }

  min_size         = 1
  max_size         = 3
  desired_capacity = 2

  vpc_zone_identifier = [aws_subnet.public.id]
}
