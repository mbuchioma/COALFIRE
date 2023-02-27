variable "vpc_cidr" {
  type        = string
  description = "The IPv4 CIDR block for the VPC"
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
}

variable "env" {
  type = string
}

variable "project" {
  type = string
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
}

variable "instance_type" {
  type = string
}

variable "ami" {
  type        = string
  description = "ami for instance"
}

variable "key_name" {
  type = string
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable transition_day {
  type        = number
  description = "Date objects are transitioned to the specified storage class"
}

variable storage_class {
  type        = string
}

variable map_public_ip_on_launch {
  type        = bool
  description = "description"
}
