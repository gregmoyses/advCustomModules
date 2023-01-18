
# Defender for Cloud Variables
variable "override-dfc-tiers" {
  type = map
  default = null
}
variable "deploy-defender-cloud" {
  type = bool
  default = true
}

# variable "notification-email" {
#   default = "azure.operations@oneadvanced.com"
# }

# variable "notification-phone" {
#   default = "+1-555-555-5555"
# }

# variable "alert-notifications" {
#   default = true
# }

# variable "alert-to-admins" {
#   default = true
# }
