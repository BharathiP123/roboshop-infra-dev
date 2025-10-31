resource "aws_instance" "mongodb" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.mongodb_sg_id]
    subnet_id = local.databse_subnet_id
    iam_instance_profile = aws_iam_instance_profile.ec2_ssm.name
    tags = merge (
        local.common_tags,
        {
            Name = "${local.common_name_suffix}-mongodb" # roboshop-dev-mongodb
        }
    )
}

##create instance profile 
resource "aws_iam_instance_profile" "ec2_ssm" {
  name = "ec2-ssm-profile"
  role = "ec2-ssm"
}


###null resource in terraform will nt create a ny resource but its used as terraform data .check "
resource "terraform_data" "mongodb" {
  triggers_replace = [aws_instance.mongodb.id]
  

connection { 

     
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.mongodb.private_ip
  }

  provisioner "file" {
   source = "bootstrap.sh" 
   destination = "/tmp/bootstrap.sh"
    
  }
  provisioner "remote-exec" {
    inline = [ 
      "chmod +x  /tmp/bootstrap.sh",
      #"sudo sh /tmp/bootstrap.sh"
      "sudo sh /tmp/bootstrap.sh mongodb"
     ]
    
  }

}

###redis 
resource "aws_instance" "redis" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.reddis_sg_id]
    subnet_id = local.databse_subnet_id
    
    tags = merge (
        local.common_tags,
        {
            Name = "${local.common_name_suffix}-redis" # roboshop-dev-mongodb
        }
    )
}

###null resource in terraform will nt create a ny resource but its used as terraform data .check "
resource "terraform_data" "redisdb" {
  triggers_replace = [aws_instance.redis.id]
  

connection { 

     
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.redis.private_ip
  }

  provisioner "file" {
   source = "bootstrap.sh" 
   destination = "/tmp/bootstrap.sh"
    
  }
  provisioner "remote-exec" {
    inline = [ 
      "chmod +x  /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh redis"
     ]
    
  }

}

###redis 
resource "aws_instance" "rabbitmq" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.rabbitmq_sg_id]
    subnet_id = local.databse_subnet_id
    
    tags = merge (
        local.common_tags,
        {
            Name = "${local.common_name_suffix}-rabbitmq" # roboshop-dev-mongodb
        }
    )
}

###null resource in terraform will nt create a ny resource but its used as terraform data .check "
resource "terraform_data" "rabbitmq" {
  triggers_replace = [aws_instance.rabbitmq.id]
  

connection { 

     
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.rabbitmq.private_ip
  }

  provisioner "file" {
   source = "bootstrap.sh" 
   destination = "/tmp/bootstrap.sh"
    
  }
  provisioner "remote-exec" {
    inline = [ 
      "chmod +x  /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh rabbitmq"
     ]
    
  }

}

###mysql

resource "aws_instance" "mysql" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.mysql_sg_id]
    subnet_id = local.databse_subnet_id
    iam_instance_profile = aws_iam_instance_profile.ec2_ssm_mysql.name
    tags = merge (
        local.common_tags,
        {
            Name = "${local.common_name_suffix}-mysql" # roboshop-dev-mongodb
        }
    )
}

##create instance profile 
resource "aws_iam_instance_profile" "ec2_ssm_mysql" {
  name = "ec2-ssm-profile-dev"
  role = "ec2-ssm"
}


###null resource in terraform will nt create a ny resource but its used as terraform data .check "
resource "terraform_data" "mysql" {
  triggers_replace = [aws_instance.mysql.id]
  

connection { 

     
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.mysql.private_ip
  }

  provisioner "file" {
   source = "bootstrap.sh" 
   destination = "/tmp/bootstrap.sh"
    
  }
  provisioner "remote-exec" {
    inline = [ 
      "chmod +x  /tmp/bootstrap.sh",
      #"sudo sh /tmp/bootstrap.sh"
      "sudo sh /tmp/bootstrap.sh mysql dev"
     ]
    
  }

}

resource "aws_route53_record" "mongodb_record" {
zone_id = var.hosted_zone_id
name = "mongodb.${var.environment}.${var.domain_name}" # Replace with your domain name
type = "A"
ttl = 1
records = [aws_instance.mongodb.private_ip]# Replace with your desired IP address
}




