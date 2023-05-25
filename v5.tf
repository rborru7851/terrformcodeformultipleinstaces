provider "aws" {
  region = "your_region"
}

# Define a list of instance configurations
variable "instance_configs" {
  type = list(object({
    name                 = string
    ami                  = string
    instance_type        = string
    subnet_id            = string
    security_group       = string
    vpc_interface        = bool
    private_ip           = optional(string)
  }))
  default = [
    {
      name                 = "instance1"
      ami                  = "ami-12345678"
      instance_type        = "t2.micro"
      subnet_id            = "subnet-12345678"
      security_group       = "sg-12345678"
      vpc_interface        = true
      private_ip           = null
    },
    {
      name                 = "instance2"
      ami                  = "ami-87654321"
      instance_type        = "t2.small"
      subnet_id            = "subnet-87654321"
      security_group       = "sg-87654321"
      vpc_interface        = false
      private_ip           = null
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

  network_interface {
    device_index         = 0

    # Conditionally assign the network interface ID
    network_interface_id = var.instance_configs[count.index].vpc_interface ? aws_network_interface.vpc_interface[count.index].id : aws_network_interface.new_interface[count.index].id

    # Conditionally assign private IP for custom network interface
    private_ip_address   = var.instance_configs[count.index].private_ip
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create VPC network interface for instance
resource "aws_network_interface" "vpc_interface" {
  count             = length(var.instance_configs)
  subnet_id         = var.instance_configs[count.index].subnet_id
  security_groups   = [var.instance_configs[count.index].security_group]
  source_dest_check = false
  lifecycle {
    create_before_destroy = true
  }
}

# Attach VPC network interface to instance
resource "aws_network_interface_attachment" "vpc_interface_attachment" {
  count                = length(var.instance_configs)
  instance_id          = aws_instance.ec2_instances[count.index].id
  network_interface_id = aws_network_interface.vpc_interface[count.index].id
  depends_on           = [aws_instance.ec2_instances[count.index]]
}

# Create new network interface for instance
resource "aws_network_interface" "new_interface" {
  count             = length(var.instance_configs)
  subnet_id         = var.instance_configs[count.index].subnet_id
  security_groups   = [var.instance_configs[count.index].security_group]
  source_dest_check = false
  lifecycle {
    create_before_destroy = true
  }
}

# Attach new network interface to instance
resource "aws_network_interface_attachment" "new_interface_attachment" {
  count                = length(var.instance_configs)
  instance_id          = aws_instance.ec
}
