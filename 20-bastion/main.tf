resource "aws_instance" "bastion" {
  ami           = local.ami_id
  vpc_security_group_ids = [local.bastion_sg_id]
  instance_type = "t3.micro"
  subnet_id = local.public_subnet_ids
  user_data = file("bastion.sh")

  tags = merge(
    local.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-bastion"
    }
  )
}
