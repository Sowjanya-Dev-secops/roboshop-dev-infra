 #backend alb accepting traffic from bastion

resource "aws_security_group_rule" "backend_alb_bastion" {
  type              = "ingress"
  security_group_id = local.backend_alb_sg_id
  source_security_group_id = local.bastion_sg_id # frontend ALB SG ID
  from_port         = 80
  protocol          = "tcp"
  to_port           = 80
}

 #backend alb accepting traffic from laptop

resource "aws_security_group_rule" "backend_laptop" {
    #backend alb accepting traffic from bastion
  type              = "ingress"
  security_group_id = local.bastion_sg_id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
}

resource "aws_security_group_rule" "mongodb_bastion" {
  type              = "ingress"
  security_group_id = local.mongodb_sg_id
  source_security_group_id = local.bastion_sg_id 
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
}

resource "aws_security_group_rule" "redis_bastion" {
  type              = "ingress"
  security_group_id = local.redis_sg_id
  source_security_group_id = local.bastion_sg_id 
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
}