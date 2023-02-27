output "sg_id" {
  description = "The ID of the SG"
  value       = aws_security_group.sg-ec2.id
}