resource "aws_lb" "alb" {
  name               =  "${var.project}-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg-alb.id]
  subnets            = var.lb_subnets

  lifecycle {
    create_before_destroy = true
  }
}

// instance target group for alb
resource "aws_lb_target_group" "alb-tg" { 
  name                 = "${var.project}-tg"
  port                 = 80
  protocol             = "HTTP"
  target_type          = var.alb_target
  vpc_id               = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 4
    timeout             = 10
    protocol            = "HTTP"
  }
}

resource "aws_lb_listener" "backend-listener_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }
}