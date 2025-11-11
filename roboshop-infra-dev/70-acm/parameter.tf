resource "aws_ssm_parameter" "certificate_arn" {
  name  = "/${var.projectname}/${var.environment}/acm_certificate_arn"
  type  = "String"
  value = aws_acm_certificate.roboshop.arn
}