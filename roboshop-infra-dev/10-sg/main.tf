# ###USing openSource module
/* # module "sg" {
#   source = "terraform-aws-modules/security-group/aws"
#   name        = local.common_name_suffix
#   use_name_prefix = false
#   description = "Security group for catalogue"
#   vpc_id      = data.aws_ssm_parameter.vpc_id.value
  
# } */

module "sg" {
    count = length(var.sg_names)
    source = "git::https://github.com/BharathiP123/terraform-modules.git//securitygroup-module"
    sg_name = "${var.sg_names[count.index]}"
    project = var.projectname
    environment = var.environment
    description = "created for ${var.sg_names[count.index]}"
    vpcid = local.vpc_id
    sg_tags = var.sg_tags

    
        

  
}

##front end security group to allow the alb sg
# resource "aws_security_group_rule" "allow_alb_sg_in_frontend_sg" {
# type = "ingress"
# from_port = 80
# to_port = 80
# protocol = "tcp"
# source_security_group_id = module.sg[11].sg_id
# security_group_id = module.sg[9].sg_id
# }