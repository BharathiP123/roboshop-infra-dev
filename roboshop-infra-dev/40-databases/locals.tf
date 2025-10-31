locals {
    ami_id = data.aws_ami.myami.id
    common_name_suffix = "${var.project_name}-${var.environment}"
    mongodb_sg_id = data.aws_ssm_parameter.mongodb_sg_id.value
    reddis_sg_id = data.aws_ssm_parameter.reddis_sg_id.value
    rabbitmq_sg_id = data.aws_ssm_parameter.reddis_sg_id.value
    mysql_sg_id = data.aws_ssm_parameter.mysql_sg_id.value
    databse_subnet_id = split("," , data.aws_ssm_parameter.database_subnet_ids.value)[0]
    common_tags = {
        Project = var.project_name
        Environment = var.environment
        Terraform = "true"
    }
}