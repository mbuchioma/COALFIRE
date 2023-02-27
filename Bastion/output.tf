output bastion_sg {
  value       = aws_security_group.bastion-sg.id
  description = "id of loadbalancer's sg"
}
