##Create catalogue ec2 instance
resource "aws_instance" "catalogue" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.catalogue_sg_id]
    subnet_id = local.private_subnet_id
    #iam_instance_profile = aws_iam_instance_profile.ec2_ssm.name
    tags = merge (
        local.common_tags,
        {
            Name = "${local.common_name_suffix}-catalogue" # roboshop-dev-mongodb
        }
    )
}

resource "terraform_data" "catalogue" {
  triggers_replace = [aws_instance.catalogue.id]
  

connection { 

     
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.catalogue.private_ip
  }

  provisioner "file" {
   source = "catalogue.sh" 
   destination = "/tmp/catalogue.sh"
    
  }
  provisioner "remote-exec" {
    inline = [ 
      "chmod +x  /tmp/catalogue.sh",
      #"sudo sh /tmp/bootstrap.sh"
      "sudo sh /tmp/catalogue.sh catalogue dev"
     ]
    
  }
}

resource "aws_route53_record" "catalogue_record" {
zone_id = local.zone_id
name = "catalogue-${var.environment}.${var.domain_name}" # Replace with your domain name
type = "A"
ttl = 1
records = [aws_instance.catalogue.private_ip]# Replace with your desired IP address
}

##ami creation for catalogue instance 



###stoping the catalogue instance

resource "aws_ec2_instance_state" "stop_instance" {
  instance_id = aws_instance.catalogue.id
  state       = "stopped"
  depends_on = [ terraform_data.catalogue ]
}

resource "aws_ami_from_instance" "catalogue_ami" {
  name               = "${local.common_name_suffix}-catalogue-ami"
  source_instance_id = aws_instance.catalogue.id
  depends_on = [ aws_ec2_instance_state.stop_instance ]
  tags = merge (
        local.common_tags,
        {
            Name = "${local.common_name_suffix}-catalogue-ami" # roboshop-dev-mongodb
        }
    )
}
