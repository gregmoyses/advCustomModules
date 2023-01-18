variable "disable-firewall" {
  type = bool
  default = false
}

variable "override-firewall-name" {
  type = string
  default = null
}

variable "override-firewall-pip-name" {
  type = string
  default = null
}

variable "override-firewall-ipcfg-name" {
  type = string
  default = null
}

variable "override-firewall-sku" {
  type = string
  default = null
  nullable = true
  validation {
    condition = (
      var.override-firewall-sku == "Premium" || var.override-firewall-sku == "Standard" || var.override-firewall-sku == null
    )
    error_message = "The firewall SKU can be either Standard or Premium."
  }
}

variable "override-fw-policy-identity-name" {
  type = string
  default = null
}

variable "disable-dns-proxy" {
  type = bool
  default = false
}

variable "firewall-dns-servers" {
  type = list(string)
  default = null
}