provider "aws" {
  region = "us-west-1"  # Update with your desired region
}

resource "aws_launch_configuration" "example_lc" {
  name_prefix   = "example-lc-"
  image_id      = "ami-12345678"  # Replace with your desired AMI ID
  instance_type = "t2.micro"

  security_groups = ["sg-12345678"]  # Replace with your security group IDs

  network_interfaces {
    device_index          = 0
    subnet_id             = "subnet-abcdef123456"
    security_groups      = ["sg-78901234"]
    associate_public_ip_address = true
  }

  network_interfaces {
    device_index          = 1
    subnet_id             = "subnet-ghijkl567890"
    security_groups      = ["sg-90123456"]
    associate_public_ip_address = false
  }
}

resource "aws_autoscaling_group" "example_asg" {
  name                 = "example-asg"
  launch_configuration = aws_launch_configuration.example_lc.name
  min_size             = 2
  max_size             = 5
  desired_capacity     = 2

  availability_zones = ["us-west-1a", "us-west-1b"]

  tag {
    key                 = "Name"
    value               = "ExampleInstance"
    propagate_at_launch = true
  }
}
