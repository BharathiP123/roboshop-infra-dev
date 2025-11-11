data "aws_ssm_parameter" "backend_alb_sg_id" {
    name = "/${var.projectname}/${var.environment}/backend_alb_sg_id"
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.projectname}/${var.environment}/public_sub_ids"
}

data "aws_route53_zone" "zone_id" {
  name         = "bpotla.com"
  private_zone = false
}

data "aws_ssm_parameter" "frontend_alb_sg_id" {
    name = "/${var.projectname}/${var.environment}/frontend_alb_sg_id"
}

data "aws_ssm_parameter" "certficate_arn" {
    name = "/${var.projectname}/${var.environment}/acm_certificate_arn"
}
