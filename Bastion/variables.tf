variable instance_type {
  type        = string
}

variable vpc_id {
  type        = string
}

variable subnet_id {
  description = "subnet to launch bastion host in"
}

variable key_name {
  type        = string
}

variable "env" {
  type = string
}

variable "project" {
  type = string
}

variable ami {
  type = string
  description = "ami for instance"
}

variable bastion_volume_size {
  type        = number
  default     = 10
  description = "size of ebs block volume for bastion host"
}

locals {
  inbound_ports = var.inbound_port
}

variable "inbound_port" {
  type = list
  default = [22]
}