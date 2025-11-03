###This is for load balancer creation ,lister and target groups for roboshop project

resource "aws_lb" "backend_alb" {
  name               = "${var.projectname}-${var.environment}-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [local.backend_sg_id]
  subnets            = local.private_subnet_id
  enable_deletion_protection = true

  tags = merge(
    local.common_tags,
    {
        Name = "${local.common_name_suffix}-backend-alb"
    }

  )
}

## backend alb listerns 

resource "aws_lb_listener" "backend_end" {
  load_balancer_arn = aws_lb.backend_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}

##create route 53 alias for alb 

resource "aws_route53_record" "alb_alias" {
  zone_id = local.zone_id
  name    = "*.backend-alb-${var.environment}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.backend_alb.dns_name
    zone_id                = aws_lb.backend_alb.zone_id
    evaluate_target_health = true
  }
}

###ssm parameter to store the alb listern arn 

resource "aws_ssm_parameter" "alb_listener_arn" {
  name  = "/${var.projectname}/${var.environment}/backend_alb_listener_arn"
  type  = "String"
  value = aws_lb_listener.backend_end.arn
}
