
data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.projectname}/${var.environment}/private_sub_ids"
}

data "aws_ssm_parameter" "catalogue_sg_id" {
  name = "/${var.projectname}/${var.environment}/catalogue_sg_id"
}

data "aws_ami" "myami"{
    owners = ["973714476881"]
    most_recent      = true
    filter {
    name   = "virtualization-type"
    values = ["hvm"]
    }
    filter {
    name = "root-device-type"
    values = ["ebs"]
    }
    filter {
    name = "name"
    values = ["RHEL-9-DevOps-Practice"]
    }

}

data "aws_route53_zone" "zone_id" {
  name         = "bpotla.com"
  private_zone = false
}

