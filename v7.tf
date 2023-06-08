locals {
  is_t_instance_type = replace(var.instance_type, "/^t(2|3|3a){1}\\..*$/", "1") == "1" ? true : false

  amz_user_data  = <<EOF
#!/bin/bash
sudo apt-get -y update
sudo apt-get -y install awscli
sudo aws s3 cp s3://vzmmp2-outpost-amitest/joinAD_SSM.sh /tmp/joinAD_SSM.sh
sudo chmod 755 /tmp/joinAD_SSM.sh
sudo /tmp/joinAD_SSM.sh --directory-id d-9067497d5f --directory-name mmp2.vzmec.com --dns-addresses 10.254.0.19 10.254.1.46
#sudo yum -y update
#sudo yum install -y awscli
#sudo aws s3 cp s3://vzmmp2-outpost-amitest/joinAD_SSM.sh /tmp/joinAD_SSM.sh && sudo chmod 755 /tmp/joinAD_SSM.sh
#/bin/bash /tmp/joinAD_SSM.sh --directory-id ${var.directoryid} --directory-name ${var.directoryname}
#sudo /usr/bin/sed -i "s/eth0/ens5/g" /tmp/joinAD_SSM.sh
#sudo /tmp/joinAD_SSM.sh --directory-id d-9067497d5f --directory-name mmp2.vzmec.com --dns-addresses 10.254.0.19 10.254.1.46
#/tmp/joinAD_SSM.sh --directory-id d-90674e9d97 --directory-name mmp2.vzmec.com
#sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
#sudo systemctl restart sshd.service
#echo "%mmp2vzmec\\linux-sudoers ALL=(ALL:ALL) ALL" >> /etc/sudoers 
#aws s3 cp s3://vzmmp2-outpost-amitest/Crowdstrike/falcon-sensor-6.45.0-14203.amzn2.x86_64.rpm /tmp
#sudo yum install -y /tmp/falcon-sensor-6.45.0-14203.amzn2.x86_64.rpm
#sudo service falcon-sensor start
EOF

#}
  directoryid     = var.directoryid
  directoryname   = var.directoryname
  ubuntu_user_data = <<EOF
#!/bin/bash
ip a > /tmp/userdatalos.log
ping -c 10 -w 5 8.8.8.8 >> /tmp/userdatalosping.log
ping -c 10 -w 5 8.8.8.8 -I ens6 >> /tmp/userdatalospingens6.log 
ping -c 10 -w 5 8.8.8.8 -I ens5 >> /tmp/userdatalospingens5.log
echo "$ip a" >> /tmp/seconduserdatalos.log
echo "$ip a" >> /tmp/userdatalos.log
sudo apt-get -y update >> /tmp/userdatalos.log
sudo apt-get -y install awscli >> /tmp/userdatalos.log
sudo apt install traceroute -y >> /tmp/userdatalos.log
sudo aws s3 cp s3://vzmmp2-outpost-amitest/joinAD_SSM.sh /tmp/joinAD_SSM.sh >> /tmp/userdatalos.log
sudo chmod 755 /tmp/joinAD_SSM.sh  >> /tmp/userdatalos.log
sudo /tmp/joinAD_SSM.sh --directory-id d-9067497d5f --directory-name mmp2.vzmec.com --dns-addresses 10.254.0.19 10.254.1.46 >> /tmp/userdatalos.log
#sudo /bin/bash /tmp/joinAD_SSM.sh --directory-id ${var.directoryid} --directory-name ${var.directoryname} >> /tmp/userdatalos.log
sudo echo "session required pam_mkhomedir.so skel=/etc/skel umask=00" >> /etc/pam.d/common-session >> /tmp/userdatalos.log
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config >> /tmp/userdatalos.log
sudo systemctl restart sshd.service >> /tmp/userdatalos.log
echo "%mmp2vzmec\\\\linux-sudoers ALL=(ALL:ALL) ALL" >> /etc/sudoers
sudo mkdir /mnt/${var.nfs-aws-netapp}  >> /tmp/userdatalos.log
sudo apt install nfs-common -y  >> /tmp/userdatalos.log
sudo apt install net-tools -y >> /tmp/userdatalos.log
mount -t nfs 10.254.4.39:/br_pmec_netapp_aws_nfs /mnt/${var.nfs-aws-netapp} >> /tmp/userdatalos.log

ip route >> /tmp/userdatalos.log
ip a >> /tmp/userdatalos.log
echo "########"
ping -c 10 -w 5 8.8.8.8 >> /tmp/userdatalosping.log
ping -c 10 -w 5 8.8.8.8 -I ens6 >> /tmp/userdatalospingens6.log 
ping -c 10 -w 5 8.8.8.8 -I ens5 >> /tmp/userdatalospingens5.log
echo "$ip a" >> /tmp/seconduserdatalos.log
EOF
}






# Create the VPC network interface
resource "aws_network_interface" "vpc_interface" {
  #count             = length(var.instance_configs)
  subnet_id         = "subnet-0acc6770b79dde778" #var.instance_configs[count.index].subnet_id
  #security_groups   = "sg-041df129bb9a4e08e" #[var.instance_configs[count.index].security_group]
  source_dest_check = true
  #device_index      = 0
  lifecycle {
    create_before_destroy = true
  }
}

# Create the new network interface
resource "aws_network_interface" "new_interface" {
#  count             = length(var.instance_configs)
  subnet_id         = "subnet-0acc6770b79dde778" #var.instance_configs[count.index].subnet_id
  #security_groups   = "sg-041df129bb9a4e08e" #"[var.instance_configs[count.index].security_group]
  source_dest_check = true
  lifecycle {
    create_before_destroy = true
  }
}

# Create the EC2 instance


resource "aws_instance" "ec2_instance" {
  ami           = "ami-01f18be4e32df20e2"
  instance_type = "c6id.4xlarge"
  #subnet_id     = "subnet-0acc6770b79dde778"
  key_name      = "rajutest"
  #associate_public_ip_address = true
  iam_instance_profile  = "PMec-LinuxEC2DomainJoin"
  user_data     = local.ubuntu_user_data
  #count         = 2
  #vpc_id     = "vpc-038d9b7cd29b43879"
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.vpc_interface.id
  }

  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.new_interface.id
  }

  tags = {
    Name = "br-ins"
    "alpha.eksctl.io/cluster-name" = "br-ins"
  }
}
/*
data "aws_eip" "elastiip" {
  public_ip  = "52.22.165.196" #"52.70.217.22"
}

#Associate EIP with EC2 Instance
resource "aws_eip_association" "demo-eip-association" {
  #count = length(var.instance_configs)
  #instance_id   = aws_instance.ec2_instance[count.index].id #aws_instance.ec2_instance[count.index].id
  network_interface_id = aws_network_interface.vpc_interface.id
  #network_interface_id = aws_network_interface.example[count.index].id #aws_network_interface.example[count.index].id
  allocation_id = data.aws_eip.elastiip.id
}
*/
/*
resource "aws_eip_association" "eip_disassociation" {
  #instance_id = aws_instance.ec2_instance.id
  network_interface_id = aws_network_interface.vpc_interface.id
  allocation_id = data.aws_eip.elastiip.id

  lifecycle {
    #ignore_changes = [instance_id]
    ignore_changes = [network_interface_id]
  }
}
*/
/*
resource "aws_eip_association" "eip_disassociation" {
  #instance_id = aws_instance.ec2_instance.id
  #provider  = aws.demo-eip-association.provider
  network_interface_id = aws_network_interface.vpc_interface.id
  allocation_id = data.aws_eip.elastiip.id

  lifecycle {
    create_before_destroy = true
    #ignore_changes = [instance_id]
    #ignore_changes = [network_interface_id]
  }
}
*/
