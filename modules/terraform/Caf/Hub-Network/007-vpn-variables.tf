variable "override-gateway-name" {
  type    = string
  default = null
}

variable "override-gateway-sku" {
  type    = string
  default = null
}

variable "override-gateway-ipcfg-name" {
  type    = string
  default = null
}

variable "override-gateway-pip-name" {
  type    = string
  default = null
}

variable "override-gateway-pip-id" {
  type    = string
  default = null
}

variable "vpn-configs" {
  type = map(object({
    gateway-address = string
    address-spaces = list(string)
    dpd-timeout = number
    protocol = string
    routing-weight = number
    shared-key = string
    policy-based-traffic = bool
    ipsec-policy = object({
      dh_group = string
      ike_encryption = string
      ike_integrity = string
      ipsec_encryption = string
      ipsec_integrity = string
      pfs_group = string
      sa_lifetime = number
      sa_datasize = number
  })
  }))
  default = null
  validation {
    condition = (
      var.vpn-configs != null ? can({for key, config in var.vpn-configs : key => cidrhost("${config.gateway-address}/32", 0)}) : true
    )
    error_message = "The gateway address for each configuration must be a valid single IP address representing the on premise gateway."
  }
  validation {
    condition = (
      var.vpn-configs != null ? alltrue([for key, config in var.vpn-configs : config.protocol != "IKEv1" && config.protocol != "IKEv2" ? false : true]) : true
    )
    error_message = "The protocol setting for each configuration must be either IKEv1 or IKEv2. This value is case-sensitive."
  }
  validation {
    condition = (
      var.vpn-configs != null ? alltrue(
        [for key, config in var.vpn-configs : config.ipsec-policy != null ?
          config.ipsec-policy.dh_group != "DHGroup1" &&
          config.ipsec-policy.dh_group != "DHGroup2" &&
          config.ipsec-policy.dh_group != "DHGroup14" &&
          config.ipsec-policy.dh_group != "DHGroup2048" &&
          config.ipsec-policy.dh_group != "DHGroup24" &&
          config.ipsec-policy.dh_group != "ECP256" &&
          config.ipsec-policy.dh_group != "ECP384" &&
          config.ipsec-policy.dh_group != "None" ? false : true
           : true]
        ) : true
    )
    error_message = "The dh_group setting for each configuration must be one of DHGroup1, DHGroup14, DHGroup2, DHGroup2048, DHGroup24, ECP256, ECP384, or None. This value is case-sensitive. ECP256, ECP384 are equivalent to DHGroup 19 and 20 respectively."
  }
}