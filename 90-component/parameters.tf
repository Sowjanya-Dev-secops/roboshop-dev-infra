resource "aws_ssm_parameter" "backend_alb_listener_arn" {
  name        = "/${var.project_name}/${var.environment}/backend_alb_listener_arn"
  description = "The parameter description"
  type        = "String"
  value       = aws_lb_listener.backend_alb.arn
}
resource "aws_ssm_parameter" "frontend_alb_listener_arn" {
  name        = "/${var.project_name}/${var.environment}/frontend_alb_listener_arn"
  description = "The parameter description"
  type        = "String"
  value       = aws_lb_listener.frontend_alb.arn
}