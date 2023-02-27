output target_group {
  value       = aws_lb_target_group.alb-tg.arn
  description = "arn of target group"
}

output alb_sg {
  value       = aws_security_group.sg-alb.id
  description = "id of loadbalancer's sg"
}

