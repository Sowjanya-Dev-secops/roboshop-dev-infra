#using open source module
# module "vote_service_sg" {
#   source = "terraform-aws-modules/security-group/aws"

#   name        = "${local.common_name_suffix}-catalouge"
#   use_name_prefix = false
#   description = "Security group for catalogue with custom ports open within VPC, egress all traffic"
#   vpc_id      = data.aws_ssm_parameter.vpc_id.value

# }

#using cusomised module
# module "sg" {
#     count=length(var.sg_names)
#     source = "git::https://github.com/Sowjanya-Dev-secops/terraform-aws-sg.git?ref=main"
#     project_name = var.project_name
#     environment_name = var.environment_name
#     sg_name = var.sg_names[count.index]
#     sg_description = "Created for ${var.sg_names[count.index]}"
#     # sg_description = "created for ${var.sg_names[count.index]}"

#     vpc_id = local.vpc_id
# }

# module "sg" {
#   count = length(var.sg_names)
#   source = "git::https://github.com/Sowjanya-Dev-secops/terraform-aws-sg.git?ref=main"
#   project_name = var.project_name
#   environment_name = var.environment_name
#   sg_name = var.sg_names[count.index]
#   sg_description = "Created for ${var.sg_names[count.index]}"
#   vpc_id =  local.vpc_id
# }


module "sg_new" {
  count = length(var.sg_names)
#   source = "git::https://github.com/daws-86s/terraform-aws-sg.git?ref=main"
  source = "git::https://github.com/Sowjanya-Dev-secops/terraform-aws-sg.git?ref=main"
  project_name = var.project_name
  environment_name = var.environment
  sg_name = var.sg_names[count.index]
  sg_description = "Created for ${var.sg_names[count.index]}"
  vpc_id =  local.vpc_id
}