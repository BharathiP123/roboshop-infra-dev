locals {
  common_name_suffix = "${var.projectname}-${var.environment}"
  #vpc_id = data.aws_ssm_parameter.vpc_id.value
  ami_id = data.aws_ami.myami.id
  catalogue_sg_id = data.aws_ssm_parameter.catalogue_sg_id.value
  private_subnet_id = split("," , data.aws_ssm_parameter.private_subnet_ids.value)
  common_tags = {
    Project = var.projectname
    Environment = var.environment
    Terraform = "true"
}
}

