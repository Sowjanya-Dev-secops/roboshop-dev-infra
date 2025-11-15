resource "aws_instance" "open_vpn" {
  ami           = local.ami_id
  vpc_security_group_ids = [local.open_vpn_sg_id]
  instance_type = "t3.micro"
  subnet_id = local.public_subnet_ids
  user_data = file("vpn.sh")
  tags = merge(
    local.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-bastion"
    }
  )
}
resource "aws_route53_record" "openvpn" {
  zone_id = var.zone_id
  name    = "openvpn.${ var.domain_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.open_vpn.public_ip]
  allow_overwrite = true
}
#here we have to check ami id and owners , you can get it once you create manually one istance