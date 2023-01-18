variable "customer-name" {
  type = string
}
variable "management-sub-ids" {
  type = list(string)
  default = []
}
variable "connectivity-sub-ids" {
  type = list(string)
  default = []
}
variable "identity-sub-ids" {
  type = list(string)
  default = []
}
variable "shared-sub-ids" {
  type = list(string)
  default = []
}
variable "sandbox-sub-ids" {
  type = list(string)
  default = []
}
variable "unmanaged-sub-ids" {
  type = list(string)
  default = []
}
variable "override-mg-name-platform" {
  type = string
  default = null
}
variable "override-mg-name-management" {
  type = string
  default = null
}
variable "override-mg-name-connectivity" {
  type = string
  default = null
}
variable "override-mg-name-identity" {
  type = string
  default = null
}
variable "override-mg-name-workloads" {
  type = string
  default = null
}
variable "override-mg-name-shared" {
  type = string
  default = null
}
variable "override-mg-name-sandbox" {
  type = string
  default = null
}
variable "override-mg-name-unmanaged" {
  type = string
  default = null
}
