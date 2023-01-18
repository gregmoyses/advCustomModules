
# Defender for Cloud Locals

locals {
  dfc-tiers-map = var.override-dfc-tiers == null ? local.default-dfc-tiers : var.override-dfc-tiers
  default-dfc-tiers = {
    "AppServices" = "Standard", 
    "Containers" = "Standard", 
    "KeyVaults" = "Standard", 
    "SqlServers" = "Standard", 
    "SqlServerVirtualMachines" = "Standard", 
    "StorageAccounts" = "Standard", 
    "VirtualMachines" = "Standard", 
    "Arm" = "Standard", 
    "Dns" = "Standard"
  }

}


#Defender for Cloud Deployment

resource "azurerm_security_center_subscription_pricing" "security-center-tiers" {
    for_each            = var.deploy-defender-cloud == true ? local.dfc-tiers-map : {}
    resource_type       = each.key
    tier                = each.value
}

# Security Center Workspace 
resource "azurerm_security_center_workspace" "security-center-workspace" {
    for_each            = var.deploy-defender-cloud == true ? toset(["1"]) : toset([])
    depends_on          = [
        azurerm_security_center_subscription_pricing.security-center-tiers
        ]

    scope               = data.azurerm_subscription.current.id
    workspace_id        = azurerm_log_analytics_workspace.la-ws-mgmt.id
}

# Contact details for Security Center
# resource "azurerm_security_center_contact" "security-center-contact" {
#     count               = var.sec-tiers-map != null ? 1:0
#     email               = var.notification-email
#     phone               = var.notification-phone

#     alert_notifications = var.alert-notifications
#     alerts_to_admins    = var.alert-to-admins
# }