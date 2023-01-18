variable "override-rv-name" {
  type = string
  default = null
}
variable "override-rv-storage-mode" {
  type = string
  default = null
  validation {
    condition = var.override-rv-storage-mode == "GeoRedundant" || var.override-rv-storage-mode == "LocallyRedundant" || var.override-rv-storage-mode == "ZoneRedundant" || var.override-rv-storage-mode == null
    error_message = "The storage mode must be one of : GeoRedundant, LocallyRedundant, ZoneRedundant or null."
  }
  nullable = true
}
variable "rv-disable-soft-delete" {
  type = bool
  default = null
}
variable "rv-encryption-key-id" {
  type = string
  default = null
}