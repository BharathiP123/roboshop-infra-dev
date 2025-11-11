locals {
  common_name_suffix = "${var.projectname}-${var.environment}"
  #vpc_id = data.aws_ssm_parameter.vpc_id.value
  frontend_alb_sg_id = data.aws_ssm_parameter.frontend_alb_sg_id.value
  zone_id = data.aws_route53_zone.zone_id.id
  certficate_arn = data.aws_ssm_parameter.certficate_arn.value
  public_subnet_id = split("," , data.aws_ssm_parameter.public_subnet_ids.value)
  common_tags = {
    Project = var.projectname
    Environment = var.environment
    Terraform = "true"
}
}

