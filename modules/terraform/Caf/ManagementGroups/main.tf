locals {
  management-sub-ids    = toset([for sub in var.management-sub-ids : "/subscriptions/${sub}"])
  identity-sub-ids      = toset([for sub in var.identity-sub-ids : "/subscriptions/${sub}"])
  connectivity-sub-ids  = toset([for sub in var.connectivity-sub-ids : "/subscriptions/${sub}"])
  shared-sub-ids        = toset([for sub in var.shared-sub-ids : "/subscriptions/${sub}"])
  sandbox-sub-ids       = toset([for sub in var.sandbox-sub-ids : "/subscriptions/${sub}"])
  unmanaged-sub-ids     = toset([for sub in var.unmanaged-sub-ids : "/subscriptions/${sub}"])
  mg-name-platform      = var.override-mg-name-platform == null ? "Platform" : var.override-mg-name-platform
  mg-name-management    = var.override-mg-name-management == null ? "Management" : var.override-mg-name-management
  mg-name-connectivity  = var.override-mg-name-connectivity == null ? "Connectivity" : var.override-mg-name-connectivity
  mg-name-identity      = var.override-mg-name-identity == null ? "Identity" : var.override-mg-name-identity
  mg-name-workloads     = var.override-mg-name-workloads == null ? "Workloads" : var.override-mg-name-workloads
  mg-name-shared        = var.override-mg-name-shared == null ? "Shared" : var.override-mg-name-shared
  mg-name-sandbox       = var.override-mg-name-sandbox == null ? "Sandbox" : var.override-mg-name-sandbox
  mg-name-unmanaged     = var.override-mg-name-unmanaged == null ? "Unmanaged" : var.override-mg-name-unmanaged

}

resource "azurerm_management_group" "customer_parent" {
  display_name = var.customer-name
}

resource "azurerm_management_group" "platform_parent" {
  display_name = local.mg-name-platform
  parent_management_group_id = azurerm_management_group.customer_parent.id
}

resource "azurerm_management_group" "management" {
  display_name = local.mg-name-management
  parent_management_group_id = azurerm_management_group.platform_parent.id
}

resource "azurerm_management_group" "connectivity" {
  display_name = local.mg-name-connectivity
  parent_management_group_id = azurerm_management_group.platform_parent.id
}

resource "azurerm_management_group" "identity" {
  display_name = local.mg-name-identity
  parent_management_group_id = azurerm_management_group.platform_parent.id
}

resource "azurerm_management_group" "workloads" {
  display_name = local.mg-name-workloads
  parent_management_group_id = azurerm_management_group.customer_parent.id
}

resource "azurerm_management_group" "shared" {
  display_name = local.mg-name-shared
  parent_management_group_id = azurerm_management_group.workloads.id
}

resource "azurerm_management_group" "sandbox" {
  display_name = local.mg-name-sandbox
  parent_management_group_id = azurerm_management_group.workloads.id
}

resource "azurerm_management_group" "unmanaged" {
  display_name = local.mg-name-unmanaged
  parent_management_group_id = azurerm_management_group.customer_parent.id
}

resource "azurerm_management_group_subscription_association" "management" {
  for_each = local.management-sub-ids
  management_group_id = azurerm_management_group.management.id
  subscription_id     = each.key
}

resource "azurerm_management_group_subscription_association" "connectivity" {
  for_each = local.connectivity-sub-ids
  management_group_id = azurerm_management_group.connectivity.id
  subscription_id     = each.key
}

resource "azurerm_management_group_subscription_association" "identity" {
  for_each = local.identity-sub-ids
  management_group_id = azurerm_management_group.identity.id
  subscription_id     = each.key
}

resource "azurerm_management_group_subscription_association" "shared" {
  for_each = local.shared-sub-ids
  management_group_id = azurerm_management_group.shared.id
  subscription_id     = each.key
}

resource "azurerm_management_group_subscription_association" "sandbox" {
  for_each = local.sandbox-sub-ids
  management_group_id = azurerm_management_group.sandbox.id
  subscription_id     = each.key
}

resource "azurerm_management_group_subscription_association" "unmanaged" {
  for_each = local.unmanaged-sub-ids
  management_group_id = azurerm_management_group.unmanaged.id
  subscription_id     = each.key
}
