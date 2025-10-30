locals {
   #common_name_suffix = "${var.projectname}-${var.environment}"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  
#   common_tags = merge(
#         var.sg_names[count.index],
#         var.sg_tags
        

        
#     )

}