resource "aws_instance" "mongodb" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.mongodb_sg_id]
    subnet_id = local.databse_subnet_id
    
    tags = merge (
        local.common_tags,
        {
            Name = "${local.common_name_suffix}-mongodb" # roboshop-dev-mongodb
        }
    )
}

###null resource in terraform will nt create a ny resource but its used as terraform data .check "
resource "terraform_data" "bootstrap" {
  triggers_replace = [aws_instance.mongodb.id]
  

connection { 

     
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.mongodb.private_ip
  }

  provisioner "remote-exec" {
   inline = [ "echo hello world" ]
    
  }

}