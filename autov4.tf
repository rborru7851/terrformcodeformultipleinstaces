locals {
  default_tags_auto = {
    csp             = "awl"
    cloud_region    = var.region
    created_date    = "7/03/2023"
    created_name    = "Raj"
    ecpd_id         = "27115"
    mec_type        = "pvmc"
    resource_type   = "mec"
    location_zipcode = "75071"
    entity_name     = "PrivateMecTeam"
    resource_id     = "EulessWindowsVM"
  }

  instance_configs_ami_auto = [
    {
      ami           = var.awsami
      instance_type = var.instancetype
      subnet_id     = aws_subnet.outpost.*.id[0]
      key_name      = var.keyname
      user_data     = <<-EOF
        #!/bin/bash
        # User data script for instance
        # Add your user data script here
        # ...
      EOF
    },
    # Add more instances configurations if needed
  ]
}

resource "aws_launch_configuration" "linux_lc" {
  count = length(local.instance_configs_ami_auto)
  name_prefix          = "linux-lc-"
  image_id             = local.instance_configs_ami_auto[count.index].ami
  instance_type        = local.instance_configs_ami_auto[count.index].instance_type
  key_name             = local.instance_configs_ami_auto[count.index].key_name
  user_data            = local.instance_configs_ami_auto[count.index].user_data
  iam_instance_profile = var.iam
  ebs_optimized        = true

  security_groups = [aws_security_group.instance_sgamii.id]

  network_interfaces {
    device_index                = 0
    subnet_id                   = local.instance_configs_ami_auto[count.index].subnet_id
    security_groups            = [aws_security_group.instance_sgamii.id]
    associate_public_ip_address = false
  }

  network_interfaces {
    device_index                = 1
    subnet_id                   = local.instance_configs_ami_auto[count.index].subnet_id
    security_groups            = [aws_security_group.instance_sgamii.id]
    associate_public_ip_address = false
  } 
}

resource "aws_autoscaling_group" "linux_asg" {
  name                 = "linux-asg"
  launch_configuration = aws_launch_configuration.linux_lc.name
  min_size             = 2
  max_size             = 5
  desired_capacity     = 2

  availability_zones = ["us-east-1a", "us-east-1b"]

  tag {
    key                 = "Name"
    value               = "ExampleInstance"
    propagate_at_launch = true
  }
}
