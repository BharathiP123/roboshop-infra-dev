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





###stoping the catalogue instance

resource "aws_ec2_instance_state" "stop_instance" {
  instance_id = aws_instance.catalogue.id
  state       = "stopped"
  depends_on = [ terraform_data.catalogue ]
}
##ami creation for catalogue instance 
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

###target group

resource "aws_lb_target_group" "catalogue" {
  name     = "${local.common_name_suffix}-catalogue"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  deregistration_delay = 60 # waiting period before deleting the instance

  health_check {
    healthy_threshold = 2
    interval = 10
    matcher = "200-299"
    path = "/health"
    port = 8080
    protocol = "HTTP"
    timeout = 2
    unhealthy_threshold = 2
  }
}

##aws lanuch template 

resource "aws_launch_template" "catalogue" {
  name = "${local.common_name_suffix}-catalogue"
  image_id = aws_ami_from_instance.catalogue_ami.id

  instance_initiated_shutdown_behavior = "terminate"


  instance_type = "t3.micro"

  vpc_security_group_ids = local.catalogue_sg_id

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      local.common_tags,
      {
        Name = "${local.common_name_suffix}-catalogue"
      }
    )
  }

   # tags attached to the volume created by instance
  tag_specifications {
    resource_type = "volume"

    tags = merge(
      local.common_tags,
      {
        Name = "${local.common_name_suffix}-catalogue"
      }
    )
  }

  # tags attached to the launch template
  tags = merge(
      local.common_tags,
      {
        Name = "${local.common_name_suffix}-catalogue"
      }
  )

}


##Auto scaling group

resource "aws_autoscaling_group" "catalogue" {
  name                      = "${local.common_name_suffix}-catalogue"
  max_size                  = 10
  min_size                  = 1
  health_check_grace_period = 100
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  launch_template {
    id = aws_launch_template.catalogue.id
    version = "$Latest"
    }

  vpc_zone_identifier       = [local.private_subnet_id]
  target_group_arns = [aws_lb_target_group.catalogue.arn]

 


  dynamic "tag" {
    for_each = merge(
      local.common_tags,
      {
        Name = "${local.common_name_suffix}-catalogue"
      }
    )
  
    content {
        key                 = "each.key"
        value               = "each.value"
        propagate_at_launch = true
        
        }
  }
    timeouts {
    delete = "15m"
    }
    
  }

##auto scaling policy 

resource "aws_autoscaling_policy" "catalogue_cpu_target_tracking" {
  name                   = "${local.common_name_suffix}-catalogue"
  autoscaling_group_name = aws_autoscaling_group.catalogue.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0
  }
}

###alb listener rule 

resource "aws_lb_listener_rule" "catalogue" {
  listener_arn = local.alb_listern_arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue.arn
  }

  condition {
    host_header {
      values = ["catalogue.backednd-alb-${var.environment}.${var.domain_name}"]
    }
  }
}


