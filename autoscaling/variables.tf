variable ami {
  type = string
  description = "ami for instance"
}

variable "project" {
  type = string
}

variable vpc_id {
  type        = string
}

variable inbound_ports {
  type        = list
  default = [80, 22]
}

variable "cidr_blocks" {
  description = "allowed IPs into the private ec2"
}

variable instance_type {
  type        = string
}

variable block_volume {
  type        = number
  default     = "10"
  description = "ebs block size"
}

data "aws_default_tags" "asg" {}

variable "healthcheck_period" {
  type = number
  description = "Time (in seconds) after instance comes into service before checking health"
  default = 300
}

variable "min_size" {
  type = number
}

variable "env" {
  type = string
}

variable "lb_subnets" {
  type = list(string)
}

variable "max_size" {
  type = number
}

variable "target_group_arns" {
  description = "target group of of the lb"
  type        = string
}

locals {
  inbound_ports = var.inbound_ports
}

data "template_file" "user_data" {
  template = file("${path.module}/userdata.sh")
}