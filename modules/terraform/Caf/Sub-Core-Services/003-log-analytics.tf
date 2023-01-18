locals {
  la-name = var.override-la-name == null ? lower("la-${local.customer-code}-${local.sub-name}-${local.location}") : lower(var.override-la-name)
  la-retention = var.override-la-retention == null ? 30 : var.override-la-retention
}

resource "azurerm_log_analytics_workspace" "la-ws-mgmt" {
  name                = local.la-name
  location            = azurerm_resource_group.core-services.location
  resource_group_name = azurerm_resource_group.core-services.name
  retention_in_days   = local.la-retention
  tags                = local.tags
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

output "la-id" {
  value = azurerm_log_analytics_workspace.la-ws-mgmt.id
}

# /* Azure Policy Assignments */
# resource "azurerm_policy_assignment" "deploylaagentwin" {
#   count                = var.enable_update_management ? 1 : 0
#   depends_on           = [azurerm_log_analytics_workspace.la-ws-mgmt]
#   name                 = "azpol-deploy-la-agent-win"
#   scope                = var.subscription-id
#   policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/0868462e-646c-4fe3-9ced-a733534b6a2c"
#   description          = "Deploy Log Analytics Agent for Windows VMs"
#   display_name         = "Deploy Windows LA Agent"
#   location             = var.la-location
#   identity {
#       type = "SystemAssigned"
#   }
#   parameters = <<PARAMETERS
#   {
#     "logAnalytics": {
#         "value": "${azurerm_log_analytics_workspace.la-ws-mgmt.id}"
#     }
#   }
# PARAMETERS
# }

# resource "azurerm_policy_assignment" "deploylaagentlx" {
#   count                = var.enable_update_management ? 1 : 0
#   depends_on           = [azurerm_log_analytics_workspace.la-ws-mgmt]
#   name                 = "azpol-deploy-la-agent-lx"
#   scope                = var.subscription-id
#   policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/053d3325-282c-4e5c-b944-24faffd30d77"
#   description          = "Deploy Log Analytics Agent for Linux VMs"
#   display_name         = "Deploy Linux LA Agent"
#   location             = var.la-location
#   identity {
#       type = "SystemAssigned"
#   }
#   parameters = <<PARAMETERS
#   {
#     "logAnalytics": {
#         "value": "${azurerm_log_analytics_workspace.la-ws-mgmt.id}"
#     }
#   }
# PARAMETERS
# }

# resource "azurerm_log_analytics_linked_service" "linked-aa" {
#   count               = var.islinkedtoaa == true ? 1 : 0
#   depends_on          = [azurerm_log_analytics_workspace.la-ws-mgmt]  
#   resource_group_name = var.la-resourcegroup
#   # workspace_name      = azurerm_log_analytics_workspace.la-ws-mgmt.name
#   workspace_id        = var.linked-aa-custom-workspace-id == "" ? "${var.subscription-id}/resourceGroups/${var.la-resourcegroup}/providers/Microsoft.OperationalInsights/workspaces/${var.la-name}" : var.linked-aa-custom-workspace-id
#   # resource_id         = var.linked-aa-id
#   read_access_id      = var.linked-aa-id
# }


# resource "azurerm_role_assignment" "winlapolicyident" {
#   count                 = var.enable_update_management ? 1 : 0
#   depends_on            = [azurerm_policy_assignment.deploylaagentwin]
#   scope                 = var.subscription-id
#   role_definition_name  = "Log Analytics Contributor"
#   principal_id          = azurerm_policy_assignment.deploylaagentwin[0].identity[0].principal_id
# }

# resource "azurerm_role_assignment" "lxlapolicyident" {
#   count                 = var.enable_update_management ? 1 : 0
#   depends_on            = [azurerm_policy_assignment.deploylaagentlx]
#   scope                 = var.subscription-id
#   role_definition_name  = "Log Analytics Contributor"
#   principal_id          = azurerm_policy_assignment.deploylaagentlx[0].identity[0].principal_id
# }

