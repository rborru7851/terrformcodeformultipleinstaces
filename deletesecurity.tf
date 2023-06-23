# Delete default security group
resource "aws_default_security_group" "default_sg" {
  count = length(aws_instance.ec2_instance)

  vpc_id = var.vpc_id
  lifecycle {
    prevent_destroy = true
  }
}

# Detach default security group from instances
resource "aws_network_interface_sg_attachment" "detach_default_sg" {
  count              = length(aws_instance.ec2_instance)
  network_interface_id = aws_instance.ec2_instance[count.index].network_interface[0].id
  security_group_id    = aws_default_security_group.default_sg[count.index].id

  depends_on = [
    aws_instance.ec2_instance[count.index]
  ]
}

# Delete default security group rule
resource "aws_security_group_rule" "delete_default_sg_rule" {
  count = length(aws_default_security_group.default_sg)

  security_group_id = aws_default_security_group.default_sg[count.index].id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"

  depends_on = [
    aws_network_interface_sg_attachment.detach_default_sg
  ]
}
