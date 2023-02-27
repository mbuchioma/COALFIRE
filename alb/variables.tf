variable "lb_subnets" {
  type = list(string)
}

variable "env" {
  type = string
}

variable alb_target {
  type        = string
  default     = "instance"
  description = "Type of target for the alb"
}

variable vpc_id {
  type        = string
}

variable "project" {
  type = string
}

locals {
  inbound_ports = [80]
}

variable "cidr_blocks" {
  description = "allowed IPs"
}