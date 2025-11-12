locals {
   ami_id = data.aws_ami.joindevops.id
   common_name_suffix = "${var.project_name}-${var.environment}"

    common_tags = {
        Project = var.project_name
        Environment = var.environment
        Terraform = true
   }
}