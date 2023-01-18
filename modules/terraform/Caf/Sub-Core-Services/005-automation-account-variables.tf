variable "override-aa-name" {
  type = string
  default = null
}
variable "override-aa-identity-name" {
  type = string
  default = null
}
variable "override-aa-identity-roles" {
  type = list(string)
  default = null
}
variable "aa-add-modules" {
  type        = list(object({
    name      = string
    version   = string
  }))
  default     = null
}