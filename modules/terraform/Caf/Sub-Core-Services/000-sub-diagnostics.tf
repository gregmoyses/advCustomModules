
locals {
  sub-diag-la-workspace = var.management-la-id == null ? azurerm_log_analytics_workspace.la-ws-mgmt.id : lower(var.management-la-id)
  sub-diag-name = "sub-${data.azurerm_subscription.current.display_name}-diagnostics"
  disable-sub-diagnostics = var.disable-sub-diagnostics == true ? toset([]) : toset(["1"])
  default-sub-diagnostics = ["Administrative","Security","ServiceHealth","Alert","Recommendation","Policy","Autoscale","ResourceHealth"]
  disabled-sub-diagnostics = []
}

resource "azurerm_monitor_diagnostic_setting" "sub-diagnostics" {
  for_each = local.disable-sub-diagnostics
  name = local.sub-diag-name
  target_resource_id = data.azurerm_subscription.current.id
  log_analytics_workspace_id = local.sub-diag-la-workspace
  dynamic "log" {
    for_each = local.default-sub-diagnostics
    content {
      category = log.value
      enabled = true
    }
  }
  dynamic "log" {
    for_each = local.disabled-sub-diagnostics
    content {
      category = log.value
      enabled = false
    }
  }
}