resource "aws_instance" "ec2_instance" {
  count = length(local.instance_configs)

  ami           = local.instance_configs[count.index].ami
  instance_type = local.instance_configs[count.index].instance_type
  subnet_id     = local.instance_configs[count.index].subnet_id
  key_name      = local.instance_configs[count.index].key_name
  user_data     = local.instance_configs[count.index].user_data
  iam_instance_profile = "PMec-LinuxEC2DomainJoin"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.vpc_interface[count.index].id
  }

  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.new_interface[count.index].id
  }

  vpc_security_group_ids = count.index % 2 == 0 ? [aws_security_group.instance_sg.id] : [aws_security_group.additional_sg.id]

  tags = {
    Name = "br-ins-${count.index + 1}"
  }
}
