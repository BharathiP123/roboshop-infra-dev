data "aws_ssm_parameter" "vpc_id" {
    name = "/${var.projectname}/${var.environment}/vpcid_ssm"
  
}


