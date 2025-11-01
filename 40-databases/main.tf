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
   # terraform copies this file to mongodb server
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh" # Path to the destination on the EC2 instance

   }
  
  provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/bootstrap.sh",
        # "sudo sh /tmp/bootstrap.sh"
        "sudo sh /tmp/bootstrap.sh mongodb"
    ]
  }

#   provisioner "remote-exec" {
#     inline = [
#         "chmod +x /tmp/bootstrap.sh",
#         # "sudo sh /tmp/bootstrap.sh"
#         "sudo sh /tmp/bootstrap.sh mongodb ${var.environment}"
#     ]
#   }
}


resource "aws_instance" "redis" {
  ami           = local.ami_id
  vpc_security_group_ids = [local.redis_sg_id]
  instance_type = "t3.micro"
  subnet_id = local.database_subnet_id

  tags = merge(
    local.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-redis"
    }
  )
}

resource "terraform_data" "redis" {
  triggers_replace = [
    aws_instance.redis.id,
  ]
  connection {
    type        = "ssh"
    user        = "ec2-user" # Or appropriate user for your AMI
    password    = "DevOps321"
    host        = aws_instance.redis.private_ip
  }
   # terraform copies this file to mongodb server
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh" # Path to the destination on the EC2 instance

   }

  provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/bootstrap.sh",
        # "sudo sh /tmp/bootstrap.sh"
        "sudo sh /tmp/bootstrap.sh redis ${var.environment}"
    ]
  }
}



resource "aws_instance" "rabbitmq" {
  ami           = local.ami_id
  vpc_security_group_ids = [local.rabbitmq_sg_id]
  instance_type = "t3.micro"
  subnet_id = local.database_subnet_id

  tags = merge(
    local.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-rabbitmq"
    }
  )
}

resource "terraform_data" "rabbitmq" {
  triggers_replace = [
    aws_instance.rabbitmq.id,
  ]
  connection {
    type        = "ssh"
    user        = "ec2-user" # Or appropriate user for your AMI
    password    = "DevOps321"
    host        = aws_instance.rabbitmq.private_ip
  }
   # terraform copies this file to mongodb server
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh" # Path to the destination on the EC2 instance

   }

  provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/bootstrap.sh",
        # "sudo sh /tmp/bootstrap.sh"
        "sudo sh /tmp/bootstrap.sh rabbitmq ${var.environment}"
    ]
  }
}

resource "aws_instance" "mysql" {
  ami           = local.ami_id
  vpc_security_group_ids = [local.mysql_sg_id]
  instance_type = "t3.micro"
  subnet_id = local.database_subnet_id
  iam_instance_profile = aws_iam_instance_profile.mysql.name

  tags = merge(
    local.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-mysql"
    }
  )
}

resource "aws_iam_instance_profile" "mysql" {
  name = "mysql"
  role = "EC2SSMParameterRead"
}

resource "terraform_data" "mysql" {
  triggers_replace = [
    aws_instance.mysql.id,
  ]
  connection {
    type        = "ssh"
    user        = "ec2-user" # Or appropriate user for your AMI
    password    = "DevOps321"
    host        = aws_instance.mysql.private_ip
  }
   # terraform copies this file to mongodb server
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh" # Path to the destination on the EC2 instance

   }

  provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/bootstrap.sh",
        # "sudo sh /tmp/bootstrap.sh"
        "sudo sh /tmp/bootstrap.sh mysql ${var.environment}"
    ]
  }
}

resource "aws_route53_record" "mongodb" {
  zone_id = var.zone_id
  name    = "mongodb-${ var.environment }.${ var.domain_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.mongodb.private_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "redis" {
  zone_id = var.zone_id
  name    = "mongodb-${ var.environment }.${ var.domain_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.redis.private_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "rabbitmq" {
  zone_id = var.zone_id
  name    = "mongodb-${ var.environment }.${ var.domain_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.rabbitmq.private_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "mysql" {
  zone_id = var.zone_id
  name    = "mongodb-${ var.environment }.${ var.domain_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.mysql.private_ip]
  allow_overwrite = true
}