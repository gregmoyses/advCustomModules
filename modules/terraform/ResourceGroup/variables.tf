variable "rg-suffix" {
    default = null
    description = "The resource group name suffix added after   rg-  to create the Resource Group vault name"
}

variable "custom-rg-name" {
    default = null
    description = "The entire name of the resource group, if the naming standard of (rg-var.rg-suffix)  can't be used"
}

variable "rg-location" {}
variable "tags" {
    default = {}
}
