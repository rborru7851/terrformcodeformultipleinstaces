locals {
  default_tagsss-auto = {
    csp             = "awl"
    cloud_region     = var.region
    created_date     = "7/03/2023"
    created_name = "Raj"
    ecpd_id         = "27115"
    mec_type         = "pvmc"
    resource_type    = "mec"
    location_zipcode = "75071"
    entity_name = "PrivateMecTeam",
    resource_id = "EulessWindowsVM"
  }
  instance_configsami-auto = [

    {
      ami           = var.awsami #"ami-09988af04120b3591" #"ami-01f18be4e32df20e2"
      instance_type = var.instancetype #"c6id.4xlarge"
      subnet_id     = aws_subnet.outpost.*.id[0] #"subnet-09de255f642aee456" #"subnet-014fcf644cc234387" #"subnet-05df9104efccc7707" #aws_subnet.eulass-outpost_id[0] #aws_subnet.outpost_subnet.id #"subnet-0acc6770b79dde778" #"subnet-0acc6770b79dde778"
      key_name      = var.keyname #"rajutest"
      user_data     = <<EOF
#!/bin/bash
# User data script for instance 2
# Add your user data script here
sudo mv /etc/dhcp/dhclient-eth1.conf /etc/dhcp/dhclient-eth1.conf.old
sudo touch /etc/dhcp/dhclient-eth1.conf
sudo echo "timeout 300;" >> /etc/dhcp/dhclient-eth1.conf
sudo dhclient
sudo ip route replace default via ${var.lni_gateway} dev eth1 >> /tmp/userdatalog.log
sudo echo "${var.bastion_route} via ${var.vpc_gateway} dev eth0" >> /etc/sysconfig/network-scripts/route-eth0
sudo echo "${var.ad_route} via ${var.vpc_gateway} dev eth0" >> /etc/sysconfig/network-scripts/route-eth0
sudo echo "GATEWAY=${var.lni_gateway}" >> /etc/sysconfig/network
sudo service network restart
sudo yum -y update
sudo yum install -y awscli
sudo aws s3 cp s3://vzmmp2-outpost-amitest/joinAD_SSM_amazonlinux_v1.sh /tmp/joinAD_SSM_amazonlinux_v1.sh && sudo chmod 755 /tmp/joinAD_SSM_amazonlinux_v1.sh
sudo /tmp/joinAD_SSM_amazonlinux_v1.sh --directory-id d-9067497d5f --directory-name mmp2.vzmec.com --dns-addresses 10.254.0.19 10.254.1.46 >> /tmp/userdatalos.log
#sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
#echo "%mmp2vzmec\\linux-sudoers ALL=(ALL:ALL) ALL" >> /etc/sudoers 
#sudo yum install -y /tmp/falcon-sensor-6.45.0-14203.amzn2.x86_64.rpm
#sudo service falcon-sensor start
sudo aws s3 cp s3://vzmmp2-outpost-server-launch-test/test_unitest.py /tmp/test_unitest.py && sudo chmod 755 /tmp/test_unitest.py
sudo python3 /tmp/test_unitest.py >> /tmp/pythoncodetestresutls.log
EOF
    },
    #*/
  ]
}
#/*
resource "aws_launch_configuration" "linux_lc" {
  count = length(local.instance_configsami-auto)
  name_prefix   = "linux-lc-"
  image_id      = local.instance_configsami-auto[count.index].ami  # Replace with your desired AMI ID
  instance_type = local.instance_configsami-auto[count.index].instance_type
  key_name      = local.instance_configsami-auto[count.index].key_name
  user_data     = local.instance_configsami-auto[count.index].user_data
  iam_instance_profile  = var.iam #"PMec-LinuxEC2DomainJoin"
  #monitoring    = true
  ebs_optimized = true

#  metadata_options {
#    http_tokens = "required"
#    http_endpoint = "enabled"
#  }

  security_groups   = [aws_security_group.instance_sgamii.id]  # Replace with your security group IDs
/*
  network_interfaces {
    device_index          = 0
    subnet_id             = local.instance_configsami-auto[count.index].subnet_id 
    security_groups      = [aws_security_group.instance_sgamii.id]
    associate_public_ip_address = false
  }

  network_interfaces {
    device_index          = 1
    subnet_id             = local.instance_configsami-auto[count.index].subnet_id
    security_groups      = [aws_security_group.instance_sgamii.id]
    associate_public_ip_address = false
  } */
}
#*/
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
