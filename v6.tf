provider "aws" {
  region = "your_region"
}

# Create the VPC network interface
resource "aws_network_interface" "vpc_interface" {
  subnet_id         = "subnet-12345678"
  security_groups   = ["sg-12345678"]
  source_dest_check = false
}

# Create the new network interface
resource "aws_network_interface" "new_interface" {
  subnet_id         = "subnet-87654321"
  security_groups   = ["sg-87654321"]
  source_dest_check = false
}

# Create the EC2 instance
resource "aws_instance" "ec2_instance" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
  subnet_id     = "subnet-12345678"
  key_name      = "your_key_pair"
  
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.vpc_interface.id
  }

  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.new_interface.id
  }

  tags = {
    Name = "your_instance_name"
  }
}
