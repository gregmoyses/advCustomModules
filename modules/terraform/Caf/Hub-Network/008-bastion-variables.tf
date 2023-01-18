variable "disable-bastion" {
  type = bool
  default = false
}

variable "override-bastion-name" {
  type = string
  default = null
}

variable "override-bastion-pip-name" {
  type = string
  default = null
}

variable "override-bastion-zones" {
  type = list(string)
  default = null
}