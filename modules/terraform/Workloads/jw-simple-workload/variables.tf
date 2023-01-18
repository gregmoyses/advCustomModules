variable "workload-name" {
  type = string
}

variable "location" {
  default = "uksouth"
  type = string
}

variable "tags" {
  default = null
  type = map
}

variable "vnet-address-spaces" {
  default = ["10.0.0.0/24"]
  type = list
}

variable "vm-size" {
  default = "Standard_B2s"
  type = string
}

variable "vm-public-ip" {
  default = false
  type = bool
}
