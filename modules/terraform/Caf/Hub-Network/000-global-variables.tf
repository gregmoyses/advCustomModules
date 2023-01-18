variable "subscription-name" {
  type = string
}
variable "customer-code" {
  type = string
  validation {
    condition = (
      length(var.customer-code) == 3
    )
    error_message = "The customer-code value must be exactly 3 characters."
  }
}
variable "location" {
  type = string
}
variable "hub-address-space" {
  type = string
  validation {
    condition = can(cidrnetmask(var.hub-address-space))
    error_message = "Variable hub-address-space be a valid IPv4 CIDR block."
  }
  validation {
    condition = parseint(split("/", var.hub-address-space)[1], 10) <= 24
    error_message = "The cidr range for the hub vnet must be at least a /24 block or larger."
  }
}
# variable "azure-region-address-spaces" {
#   type = list(string)
#   description = "All address space(s) allocated to the current azure region in cidrnotation"
#   validation {
#     condition = alltrue([
#       for address in var.azure-region-address-spaces : can(cidrnetmask(address))
#     ])
#     error_message = "All elements must be valid IPv4 CIDR block addresses."
#   }
# }
variable "management-la-id" {
  type = string
  default = null
}
variable "tags" {
  type = map(string)
  default = {}
  validation {
    condition = (
      contains(keys(var.tags), "Environment") && contains(keys(var.tags), "Adv-Service-Class") && contains(keys(var.tags), "Cost-Center")
    )
    error_message = "The tags variable must contain all 3 of the following tags in a map. Environment, Adv-Service-Class and Cost-Center."
  }
  validation {
    condition = (
      try(var.tags["Environment"] == "Production" || var.tags["Environment"] == "Development" || var.tags["Environment"] == "UAT", false)
    )
    error_message = "The Environment tag must be one of Production, Development or UAT."
  }
  validation {
    condition = (
      try(var.tags["Adv-Service-Class"] == "Bronze" || var.tags["Adv-Service-Class"] == "Silver" || var.tags["Adv-Service-Class"] == "Gold", false)
    )
    error_message = "The Adv-Service-Class tag must be one of Bronze, Silver or Gold."
  }
  validation {
    condition = (
      try(var.tags["Cost-Center"] != "", false)
    )
    error_message = "The Cost-Center tag must be populated."
  }
}