provider "aws" {
  region = "your_region"
}

# Define a list of instance configurations
variable "instance_configs" {
  type = list(object({
    name              = string
    ami               = string
    instance_type     = string
    subnet_id         = string
    security_group    = string
    vpc_id            = string
  }))
  default = [
    {
      name              = "instance1"
      ami               = "ami-12345678"
      instance_type     = "t2.micro"
      subnet_id         = "subnet-12345678"
      security_group    = "sg-12345678"
      vpc_id            = "vpc-12345678"
    },
    {
      name              = "instance2"
      ami               = "ami-87654321"
      instance_type     = "t2.small"
      subnet_id         = "subnet-87654321"
      security_group    = "sg-87654321"
      vpc_id            = "vpc-87654321"
    }
    # Add more instance configurations as needed
  ]
}

# Create multiple EC2 instances based on the instance configurations
resource "aws_instance" "ec2_instances" {
  count = length(var.instance_configs)

  ami           = var.instance_configs[count.index].ami
  instance_type = var.instance_configs[count.index].instance_type
  subnet_id     = var.instance_configs[count.index].subnet_id
  tags = {
    Name = var.instance_configs[count.index].name
  }

  vpc_security_group_ids = [var.instance_configs[count.index].security_group]
}

# Create network interfaces and associate them with subnets
resource "aws_network_interface" "example" {
  count       = length(var.instance_configs)
  subnet_id   = var.instance_configs[count.index].subnet_id
  security_groups = [var.instance_configs[count.index].security_group]
}

# Associate network interfaces with instances
resource "aws_network_interface_attachment" "example" {
  count                = length(var.instance_configs)
  instance_id          = aws_instance.ec2_instances[count.index].id
  network_interface_id = aws_network_interface.example[count.index].id
}

# Associate security groups with network interfaces
resource "aws_network_interface_sg_attachment" "example" {
  count       = length(var.instance_configs)
  security_group_id    = var.instance_configs[count.index].security_group
  network_interface_id = aws_network_interface.example[count.index].id
}

# Attach VPCs to instances
resource "aws_instance" "vpc_attachment" {
  count         = length(var.instance_configs)
  instance_id   = aws_instance.ec2_instances[count.index].id
  subnet_id     = var.instance_configs[count.index].subnet_id
  vpc_security_group_ids = [var.instance_configs[count.index].security_group]
}
