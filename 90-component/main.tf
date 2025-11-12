# module "component" {
#   source = "../../terraform-roboshop-component"
#   component=var.component
#   rule_priority = var.rule_priority
# }
module "components" {
    for_each = var.components
    source = "git::https://github.com/Sowjanya-Dev-secops/terraform-roboshop-component.git?ref=min"
    component=each.key
    rule_priority = each.value.rule_priority
}