locals {
  instance_configs = [
    {
      ami           = "ami-01f18be4e32df20e2"
      instance_type = "c6id.4xlarge"
      subnet_id     = "subnet-0acc6770b79dde778"
      key_name      = "rajutest"
      user_data     = <<EOF
#!/bin/bash
# User data script for instance 1
# Add your user data script here
EOF
    },
    {
      ami           = "ami-01f18be4e32df20e2"
      instance_type = "c5.large"
      subnet_id     = "subnet-0acc6770b79dde778"
      key_name      = "rajutest"
      user_data     = <<EOF
#!/bin/bash
# User data script for instance 2
# Add your user data script here
EOF
    }
  ]
}

# Create the VPC network interface
resource "aws_network_interface" "vpc_interface" {
  subnet_id         = local.instance_configs[0].subnet_id
  source_dest_check = true
  lifecycle {
    create_before_destroy = true
  }
}

# Create the new network interface
resource "aws_network_interface" "new_interface" {
  subnet_id         = local.instance_configs[1].subnet_id
  source_dest_check = true
  lifecycle {
    create_before_destroy = true
  }
}

# Create the EC2 instances
resource "aws_instance" "ec2_instance" {
  count = length(local.instance_configs)

  ami           = local.instance_configs[count.index].ami
  instance_type = local.instance_configs[count.index].instance_type
  subnet_id     = local.instance_configs[count.index].subnet_id
  key_name      = local.instance_configs[count.index].key_name
  user_data     = local.instance_configs[count.index].user_data

  network_interface {
    device_index         = 0
    network_interface_id = "existing-interface-id" // Replace with your existing interface ID
  }

  network_interface {
    device_index         = 1
    subnet_id            = local.instance_configs[count.index].subnet_id
    security_groups      = ["security-group-id"] // Replace with the security group ID for the new interface
    source_dest_check    = true
  }

  tags = {
    Name = "br-ins-${count.index + 1}"
  }
}

# Associate existing Elastic IP with the existing network interface
resource "aws_eip_association" "existing_interface_eip_association" {
  instance_id             = aws_instance.ec2_instance[0].id
  network_interface_id    = "existing-interface-id" // Replace with your existing interface ID
  allocation_id           = "eip-allocation-id" // Replace with the allocation ID of your Elastic IP
}
