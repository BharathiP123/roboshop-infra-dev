data "aws_ssm_parameter" "backend_alb_sg_id" {
    name = "/${var.projectname}/${var.environment}/backend_alb_sg_id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.projectname}/${var.environment}/private_sub_ids"
}