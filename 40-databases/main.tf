resource "aws_instance" "mongodb" {
  ami           = local.ami_id
  vpc_security_group_ids = [local.mongodb_sg_id]
  instance_type = "t3.micro"
  subnet_id = local.database_subnet_id

  tags = merge(
    local.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-mongodb"
    }
  )
}


resource "terraform_data" "mongodb" {
  triggers_replace = [
    aws_instance.mongodb.id,
  ]
  connection {
    type        = "ssh"
    user        = "ec2-user" # Or appropriate user for your AMI
    password    = "DevOps321"
    host        = aws_instance.mongodb.private_ip
  }
  provisioner "remote-exec" {
    inline = [
       "echo jasvitha hello"
    ]
  }
}

