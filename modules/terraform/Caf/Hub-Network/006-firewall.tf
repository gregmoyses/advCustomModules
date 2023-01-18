locals {
  firewall-enabled          = var.disable-firewall == true ? toset([]) : toset(["1"])
  firewall-name             = var.override-firewall-name == null ? lower("azfw-${local.base-name}") : lower(var.override-firewall-name)
  firewall-pip-name         = var.override-firewall-pip-name == null ? lower("pip-${local.firewall-name}") : lower(var.override-firewall-pip-name)
  firewall-pip-method       = "Static"
  firewall-pip-sku          = "Standard"
  firewall-sku-name         = "AZFW_VNet"
  firewall-sku-tier         = var.override-firewall-sku == null ? "Standard" : var.override-firewall-sku
  firewall-ip-config-name   = var.override-firewall-ipcfg-name == null ? lower("ipcfg-${local.firewall-name}") : lower(var.override-firewall-ipcfg-name)
  firewall-diagnostics      = var.management-la-id == null || var.disable-firewall == true ? toset([]) : toset(["1"])
  firewall-diagnostics-name = "diag-${local.firewall-name}"
  firewall-la-id            = var.management-la-id == null ? null : var.management-la-id
  firewall-la-destination   = "Dedicated"
  firewall-policy-name      = "azfw-base-policy-${local.base-name}"
  fw-policy-identity        = var.override-fw-policy-identity-name == null ? lower("mi-fw-policy-${local.base-name}") : lower(var.override-fw-policy-identity-name)
  fw-policy-dns-proxy       = var.disable-dns-proxy == true ? false : true
  fw-policy-dns-servers     = var.firewall-dns-servers == null ? null : var.firewall-dns-servers
  fw-policy-dns-block       = local.fw-policy-dns-proxy == true || local.fw-policy-dns-servers != null ? toset(["1"]) : toset([])
}

resource "azurerm_public_ip" "pip-azfw" {
  for_each            = local.firewall-enabled
  name                = local.firewall-pip-name
  location            = azurerm_resource_group.hub-net.location
  resource_group_name = azurerm_resource_group.hub-net.name
  allocation_method   = local.firewall-pip-method
  sku                 = local.firewall-pip-sku
  tags                = local.tags
}

resource "azurerm_user_assigned_identity" "fw-policy-identity" {
  location                      = azurerm_resource_group.hub-net.location
  resource_group_name           = azurerm_resource_group.hub-net.name
  name                          = local.fw-policy-identity
  tags                          = local.tags
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

# resource "azurerm_role_assignment" "fw-policy-identity-role-assignment" {
#   for_each             = local.aa-identity-roles
#   scope                = data.azurerm_subscription.current.id
#   role_definition_name = each.key
#   principal_id         = azurerm_user_assigned_identity.aa-managed-identity.principal_id
# }

resource "azurerm_firewall_policy" "base_policy" {
  name                = local.firewall-policy-name
  location            = azurerm_resource_group.hub-net.location
  resource_group_name = azurerm_resource_group.hub-net.name
  sku                 = local.firewall-sku-tier
  dynamic "dns" {
    for_each = local.fw-policy-dns-block
    content {
      proxy_enabled = local.fw-policy-dns-proxy
      servers       = local.fw-policy-dns-servers
    }
  }
}

resource "azurerm_firewall" "az-fw" {
  for_each            = local.firewall-enabled
  name                = local.firewall-name
  location            = azurerm_resource_group.hub-net.location
  resource_group_name = azurerm_resource_group.hub-net.name
  sku_name            = local.firewall-sku-name
  sku_tier            = local.firewall-sku-tier
  firewall_policy_id  = azurerm_firewall_policy.base_policy.id
  tags                = local.tags

  ip_configuration {
    name                 = local.firewall-ip-config-name
    subnet_id            = azurerm_subnet.hub_subnet["AzureFirewallSubnet"].id
    public_ip_address_id = azurerm_public_ip.pip-azfw["1"].id
  }
}

resource "azurerm_monitor_diagnostic_setting" "az-fw" {
  for_each                        = local.firewall-diagnostics
  name                            = local.firewall-diagnostics-name
  target_resource_id              = azurerm_firewall.az-fw["1"].id
  log_analytics_workspace_id      = local.firewall-la-id
  log_analytics_destination_type  = local.firewall-la-destination

  log {
    category = "AzureFirewallApplicationRule"
    enabled  = true

    retention_policy {
      enabled = true
      days = 30
    }
  }
  log {
    category = "AzureFirewallNetworkRule"
    enabled  = true

    retention_policy {
      enabled = true
      days = 30
    }
  }
  log {
    category = "AzureFirewallDnsProxy"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AZFWApplicationRule"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
log {
    category = "AZFWApplicationRuleAggregation"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
log {
    category = "AZFWDnsQuery"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
log {
    category = "AZFWFqdnResolveFailure"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
log {
    category = "AZFWIdpsSignature"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
log {
    category = "AZFWNatRule"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
log {
    category = "AZFWNatRuleAggregation"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
log {
    category = "AZFWNetworkRule"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
log {
    category = "AZFWNetworkRuleAggregation"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
log {
    category = "AZFWThreatIntel"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
}
