resource "aws_ssm_parameter" "vpc_id" {
  name        = "/${var.project_name}/${var.environment}/vpc_id"
  description = "The parameter description"
  type        = "String"
  value       = module.vpc.vpc_id

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "public_subnet_ids" {
  name        = "/${var.project_name}/${var.environment}/public_subnet_ids"
  description = "The parameter description"
  type        = "String"
  value       = join(",",module.vpc.public_subnet_ids)
}
resource "aws_ssm_parameter" "private_subnet_ids" {
  name        = "/${var.project_name}/${var.environment}/private_subnet_ids"
  description = "The parameter description"
  type        = "String"
  value       = join(",",module.vpc.private_subnet_ids)
}
resource "aws_ssm_parameter" "database_subnet_ids" {
  name        = "/${var.project_name}/${var.environment}/database_subnet_ids"
  description = "The parameter description"
  type        = "String"
  value       = join(",",module.vpc.database_subnet_ids)
}