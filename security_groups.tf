resource "aws_security_group" "main_vpc_sg" {
  count = 1

  name        = "${local.env_prefix}-main-sg"
  description = "Main vpc security Group"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "${local.env_prefix}-main-sg"
  }
}

resource "aws_security_group_rule" "main_vpc_ingress" {
  count = 1

  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = -1
  self              = true
  security_group_id = aws_security_group.main_vpc_sg[count.index].id
}

resource "aws_security_group_rule" "main_vpc_egress" {
  count = 1

  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.main_vpc_sg[count.index].id
}
