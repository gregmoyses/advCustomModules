locals {
  aa-name            = var.override-aa-name == null ? lower("aa-${local.customer-code}-${local.sub-name}-${local.location}") : lower(var.override-aa-name)
  aa-sku             = "Basic"
  aa-identity-type   = "UserAssigned"
  aa-identity        = var.override-aa-identity-name == null ? lower("mi-aa-${local.customer-code}-${local.sub-name}-${local.location}") : lower(var.override-aa-identity-name)
  aa-identity-roles  = var.override-aa-identity-roles == null ? toset(["Virtual Machine Contributor"]) : toset(var.override-aa-identity-roles)
  aa-modules-list    = var.aa-add-modules == null ? local.default-aa-modules : concat(local.default-aa-modules, var.aa-add-modules)
  aa-modules         = {for module in local.aa-modules-list: module.name => module}
  ps-gallery-uri     = "https://www.powershellgallery.com/api/v2/package"
  default-aa-modules = [
    {
      name    = "NetworkingDSC"
      version = null
    },
    {
      name    = "cChoco"
      version = null
    },
    {
      name    = "StorageDSC"
      version = null
    },
    {
      name    = "OMSIngestionAPI"
      version = null
    }
  ]
}

resource "azurerm_user_assigned_identity" "aa-managed-identity" {
  location                      = azurerm_resource_group.core-services.location
  resource_group_name           = azurerm_resource_group.core-services.name
  name                          = local.aa-identity
  tags                          = local.tags
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_automation_account" "aa-core" {
  name                          = local.aa-name
  location                      = azurerm_resource_group.core-services.location
  resource_group_name           = azurerm_resource_group.core-services.name
  sku_name                      = local.aa-sku
  tags                          = local.tags
  identity {
    type                        = local.aa-identity-type
    identity_ids                = [azurerm_user_assigned_identity.aa-managed-identity.id]
  }
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_role_assignment" "aa-identity-role-assignment" {
  for_each             = local.aa-identity-roles
  scope                = data.azurerm_subscription.current.id
  role_definition_name = each.key
  principal_id         = azurerm_user_assigned_identity.aa-managed-identity.principal_id
}

resource "azurerm_automation_module" "aa-modules" {
  for_each                = local.aa-modules

  name                    = each.value.name
  resource_group_name     = azurerm_resource_group.core-services.name
  automation_account_name = azurerm_automation_account.aa-core.name
  module_link {
    uri                   = each.value.version == null ? join("/", [local.ps-gallery-uri, each.value.name]) : join("/", [local.ps-gallery-uri, each.value.name, each.value.version])
  }
}

output "aa-id" {
  value = azurerm_automation_account.aa-core.id
}