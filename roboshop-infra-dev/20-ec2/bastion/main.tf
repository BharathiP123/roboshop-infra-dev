resource "aws_instance" "bastion" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.bastion_sg_id]
    subnet_id = local.public_subnet_id
    user_data = file("./bastion.sh")
    iam_instance_profile = aws_iam_instance_profile.ec2_terrform.name
    tags = merge (
        local.common_tags,
        {
            Name = "${var.project_name}-${var.environment}-bastion"
        }
    )
}



resource "aws_iam_instance_profile" "ec2_terrform" {
  name = "ec2terraform-admin"
  role = "bastion-terraform-admin"
}

