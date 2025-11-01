#create ec2 instance
resource "aws_instance" "catalogue" {
  ami           = local.ami_id
  vpc_security_group_ids = [local.catalogue_sg_id]
  instance_type = "t3.micro"
  subnet_id = local.private_subnet_id

  tags = merge(
    local.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-catalogue"
    }
  )
}

# connect to instance using remote-excec provisioner through terraform_data
resource "terraform_data" "catalogue" {
  triggers_replace = [
    aws_instance.mongodb.id,
  ]
  connection {
    type        = "ssh"
    user        = "ec2-user" # Or appropriate user for your AMI
    password    = "DevOps321"
    host        = aws_instance.catalogue.private_ip
  }
   # terraform copies this file to catalogue server
  provisioner "file" {
    source      = "catalogue.sh"
    destination = "/tmp/catalogue.sh" # Path to the destination on the EC2 instance

   }

  provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/catalogue.sh",
        # "sudo sh /tmp/bootstrap.sh"
        "sudo sh /tmp/catalogue.sh catalogue ${ var.environment}"
    ]
  }
}

resource "aws_ec2_instance_state" "catalogue" {
      instance_id = aws_instance.catalogue.id
      state       = "stopped"
}

resource "aws_ami_from_instance" "catalogue" {
  name               = "${local.common_name_suffix}-catalouge-ami"
  source_instance_id = aws_instance.catalogue.id
  depends_on = [ aws_ec2_instance_state.catalogue ]
}

resource "aws_route53_record" "catalogue" {
  zone_id = var.zone_id
  name    = "mongodb-${ var.environment }.${ var.domain_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.catalogue.private_ip]
  allow_overwrite = true
}

