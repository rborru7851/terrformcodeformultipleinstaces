resource "aws_security_group" "instance_sg" {
  name        = "instance-security-group"
  description = "Security group for EC2 instances"
  vpc_id      = module.mmp2_vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "instance-security-group"
  }
}

resource "aws_security_group" "additional_sg" {
  name        = "additional-security-group"
  description = "Additional security group for EC2 instances"
  vpc_id      = module.mmp2_vpc.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "additional-security-group"
  }
}

resource "aws_instance" "ec2_instance" {
  # ... your existing instance configuration ...

  security_groups = [
    aws_security_group.instance_sg.id,
    aws_security_group.additional_sg.id
  ]

  # ... rest of your instance configuration ...
}
