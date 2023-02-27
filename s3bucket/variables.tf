

variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "expiration" {
  type = number
  default = 90
  description = " specifies the expiration for the lifecycle of the object in the form of date, days and, whether the object has a delete marker"
}

variable transition_day {
  type        = number
  description = "Date objects are transitioned to the specified storage class"
}

variable storage_class {
  type        = string
}
