# Lighthouse Variables

variable "override-lh-namedef" {
    type = string
    default = null
}
variable "override-lh-scope"{
    type = string
    default = null
}
variable "override-lh-assign-scope" {
  type = string
  default = null
}
variable "override-lh-description" {
    type = string
    default = null
}
variable "override-lh-mtenant-id" {
    type = string
    default = null
}

variable "override-lh-authorization" {
    # type    = list( object ({
    #     role-def-id                     = string
    #     principal-id                    = string
    #     delegated-role-def-ids          = list(string)
    #     principal-display-name          = string
    # }))
    default = null
}