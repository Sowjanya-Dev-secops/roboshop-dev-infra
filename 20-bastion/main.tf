resource "aws_instance" "bastion" {
  ami           = local.ami_id
  vpc_security_group_ids = [local.bastion_sg_id]
  instance_type = "t3.micro"
  subnet_id = local.public_subnet_ids
  user_data = file("bastion.sh")
  iam_instance_profile = aws_iam_instance_profile.bastion.name
  # need more for terraform
  root_block_device {
    volume_size = 50
    volume_type = "gp3" # or "gp2", depending on your preference
  }


  tags = merge(
    local.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-bastion"
    }
  )
}
resource "aws_iam_instance_profile" "bastion" {
  name = "bastio"
  role =  "BastionTerraformAdmin"
}
