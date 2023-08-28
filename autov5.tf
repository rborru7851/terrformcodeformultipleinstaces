provider "aws" {
  region = "us-west-1"  # Change this to your desired AWS region
}

resource "aws_launch_template" "example" {
  name_prefix   = "example-"
  
  image_id      = "ami-12345678"  # Replace with the appropriate Amazon Linux AMI ID
  instance_type = "t2.micro"      # Replace with your desired instance type
  
  block_device_mappings = [
    {
      device_name = "/dev/xvda",
      ebs {
        volume_size = 8
        volume_type = "gp2"
      }
    },
    {
      device_name = "/dev/xvdb",
      ebs {
        volume_size = 8
        volume_type = "gp2"
      }
    }
  ]

  user_data = <<-EOF
              #!/bin/bash
              # Configure additional network interface eth1
              echo "auto eth1" >> /etc/network/interfaces
              echo "iface eth1 inet dhcp" >> /etc/network/interfaces
              ifup eth1
              EOF
  
  network_interfaces {
    device_index = 0
    subnet_id = "subnet-abcdef123456"
    security_groups = ["sg-78901234"]
    associate_public_ip_address = true
  }

  network_interfaces {
    device_index = 1
    subnet_id = "subnet-ghijkl567890"
    security_groups = ["sg-90123456"]
    associate_public_ip_address = false
  }
}

resource "aws_autoscaling_group" "example" {
  name                 = "example-asg"
  launch_template {
    id = aws_launch_template.example.id
  }
  
  min_size             = 1
  max_size             = 3
  desired_capacity     = 1
  
  vpc_zone_identifier = ["subnet-abcdef123456"]  # Replace with your subnet IDs
  
  target_group_arns = ["arn:aws:elasticloadbalancing:us-west-1:123456789012:targetgroup/example-tg/abcdef123456"]  # Replace with your target group ARN
  
  lifecycle {
    create_before_destroy = true
  }
}
