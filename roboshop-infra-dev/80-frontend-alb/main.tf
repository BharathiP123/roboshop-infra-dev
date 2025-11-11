###This is for load balancer creation ,lister and target groups for roboshop project

resource "aws_lb" "frontend_alb" {
  name               = "${var.projectname}-${var.environment}-frontend"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [local.frontend_alb_sg_id]
  subnets            = local.public_subnet_id
  enable_deletion_protection = false

  tags = merge(
    local.common_tags,
    {
        Name = "${local.common_name_suffix}-frontend-alb"
    }

  )
}

## frontend alb listerns 

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.frontend_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-3-2021-06"
  certificate_arn   = local.certficate_arn

   default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}


##create route 53  records alias for frontend alb 

resource "aws_route53_record" "frontend_alb_alias" {
  zone_id = local.zone_id
  name    = "roboshop-${var.environment}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.frontend_alb.dns_name
    zone_id                = aws_lb.frontend_alb.zone_id
    evaluate_target_health = true
  }
}

###ssm parameter to store the alb listern arn 

resource "aws_ssm_parameter" "frontend_listener_arn" {
  name  = "/${var.projectname}/${var.environment}/frontend_alb_listener_arn"
  type  = "String"
  value = aws_lb_listener.front_end.arn
}
