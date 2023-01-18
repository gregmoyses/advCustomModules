# resource "azurerm_log_analytics_solution" "law_solution_updates" {
#   count                 = var.enable_update_management ? 1 : 0
#   depends_on            = [azurerm_log_analytics_linked_service.linked-aa]
#   resource_group_name   = var.la-resourcegroup
#   location              = var.la-location
#   tags                  = var.tags-la-updates

#   solution_name         = "Updates"
#   workspace_resource_id = azurerm_log_analytics_workspace.la-ws-mgmt.id
#   workspace_name        = azurerm_log_analytics_workspace.la-ws-mgmt.name

#   plan {
#     publisher = "Microsoft"
#     product   = "OMSGallery/Updates"
#   }
# }

# resource "azurerm_log_analytics_solution" "law_solution_adassessment" {
#   count                 = var.enable_adassessment_solution ? 1 : 0
#   depends_on            = [azurerm_log_analytics_linked_service.linked-aa]
#   resource_group_name   = var.la-resourcegroup
#   location              = var.la-location
#   tags                  = var.tags-la-adassessment

#   solution_name         = "ADAssessment"
#   workspace_resource_id = azurerm_log_analytics_workspace.la-ws-mgmt.id
#   workspace_name        = azurerm_log_analytics_workspace.la-ws-mgmt.name

#   plan {
#     publisher = "Microsoft"
#     product   = "OMSGallery/ADAssessment"
#   }
# }

# resource "azurerm_log_analytics_solution" "law_solution_security" {
#   count                 = var.enable_security_solution ? 1 : 0
#   depends_on            = [azurerm_log_analytics_linked_service.linked-aa]
#   resource_group_name   = var.la-resourcegroup
#   location              = var.la-location
#   tags                  = var.tags-la-security

#   solution_name         = "Security"
#   workspace_resource_id = azurerm_log_analytics_workspace.la-ws-mgmt.id
#   workspace_name        = azurerm_log_analytics_workspace.la-ws-mgmt.name

#   plan {
#     publisher = "Microsoft"
#     product   = "OMSGallery/Security"
#   }
# }

# resource "azurerm_log_analytics_solution" "law_solution_networkmonitoring" {
#   count                 = var.enable_networkmonitoring_solution ? 1 : 0
#   depends_on            = [azurerm_log_analytics_linked_service.linked-aa]
#   resource_group_name   = var.la-resourcegroup
#   location              = var.la-location
#   tags                  = var.tags-la-networkmonitoring

#   solution_name         = "NetworkMonitoring"
#   workspace_resource_id = azurerm_log_analytics_workspace.la-ws-mgmt.id
#   workspace_name        = azurerm_log_analytics_workspace.la-ws-mgmt.name

#   plan {
#     publisher = "Microsoft"
#     product   = "OMSGallery/NetworkMonitoring"
#   }
# }

# resource "azurerm_log_analytics_solution" "law_solution_securitycenterfree" {
#   count                 = var.enable_securitycenterfree_solution ? 1 : 0
#   depends_on            = [azurerm_log_analytics_linked_service.linked-aa]
#   resource_group_name   = var.la-resourcegroup
#   location              = var.la-location
#   tags                  = var.tags-la-securitycenterfree

#   solution_name         = "SecurityCenterFree"
#   workspace_resource_id = azurerm_log_analytics_workspace.la-ws-mgmt.id
#   workspace_name        = azurerm_log_analytics_workspace.la-ws-mgmt.name

#   plan {
#     publisher = "Microsoft"
#     product   = "OMSGallery/SecurityCenterFree"
#   }
# }

# resource "azurerm_log_analytics_solution" "VMInsights" {
#   count                 = var.enable_vminsights_solution ? 1 : 0
#   resource_group_name   = var.la-resourcegroup
#   location              = var.la-location
#   tags                  = var.tags-la-vminsights

#   solution_name         = "VMInsights"
#   workspace_resource_id = azurerm_log_analytics_workspace.la-ws-mgmt.id
#   workspace_name        = azurerm_log_analytics_workspace.la-ws-mgmt.name

#   plan {
#     publisher = "Microsoft"
#     product   = "OMSGallery/VMInsights"
#   }
# }

# # resource "azurerm_log_analytics_solution" "law_solution_azure_sql_db" {
# #   count                 = var.enable_azure_sql_db_solution ? 1 : 0
# #   resource_group_name   = var.la-resourcegroup
# #   location              = var.la-location

# #   solution_name         = "Microsoft Azure SQL Database - Security Insights and Access to Sensitive Data"
# #   workspace_resource_id = azurerm_log_analytics_workspace.la-ws-mgmt.id
# #   workspace_name        = azurerm_log_analytics_workspace.la-ws-mgmt.name

# #   plan {
# #     publisher = "Microsoft"
# #     product   = "Microsoft Azure SQL Database - Security Insights and Access to Sensitive Data"
# #   }
# # }
# resource "azurerm_log_analytics_solution" "servicemap" {
#   count                 = var.servicemap-enable == true ? 1: 0
#   depends_on            = [azurerm_log_analytics_workspace.la-ws-mgmt, azurerm_log_analytics_linked_service.linked-aa]
#   solution_name         = "ServiceMap${azurerm_log_analytics_workspace.la-ws-mgmt.name}"
#   location              = azurerm_log_analytics_workspace.la-ws-mgmt.location
#   resource_group_name   = azurerm_log_analytics_workspace.la-ws-mgmt.resource_group_name
#   workspace_resource_id = azurerm_log_analytics_workspace.la-ws-mgmt.id
#   workspace_name        = azurerm_log_analytics_workspace.la-ws-mgmt.name
#   plan {
#     publisher = "Microsoft"
#     product   = "OMSGallery/ServiceMap"
#   }
# }
# resource "azurerm_log_analytics_solution" "infrainsights" {
#   count                 = var.infrainsights-enable == true ? 1: 0
#   depends_on            = [azurerm_log_analytics_workspace.la-ws-mgmt, azurerm_log_analytics_linked_service.linked-aa]
#   solution_name         = "InfrastructureInsights${azurerm_log_analytics_workspace.la-ws-mgmt.name}"
#   location              = azurerm_log_analytics_workspace.la-ws-mgmt.location
#   resource_group_name   = azurerm_log_analytics_workspace.la-ws-mgmt.resource_group_name
#   workspace_resource_id = azurerm_log_analytics_workspace.la-ws-mgmt.id
#   workspace_name        = azurerm_log_analytics_workspace.la-ws-mgmt.name
#   plan {
#     publisher = "Microsoft"
#     product   = "OMSGallery/InfrastructureInsights"
#   }
# }

# resource "null_resource" "default-data-sources" {
#   count               = var.default-data-sources == true ? 1 : 0
#   depends_on          = [azurerm_log_analytics_workspace.la-ws-mgmt]
  
#   triggers            = {
#       la-id = "azurerm_log_analytics_workspace.la-ws-mgmt.id"
#   }
#   #LA WS ID = $1

#   provisioner "local-exec" {
#       command = "$ADV365_SHARED_SCRIPTS_ROOT_DIR/azure/az-cli-shared-scripts/log-analytics/default-data-sources.py ${azurerm_log_analytics_workspace.la-ws-mgmt.id}"
#   }
# }