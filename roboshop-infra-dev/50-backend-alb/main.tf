###This is for load balancer creation ,lister and target groups for roboshop project

resource "aws_lb" "backend_alb" {
  name               = "${var.projectname}-${var.environment}-alb"
  internal           = false
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

resource "aws_lb_listener" "front_end" {
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