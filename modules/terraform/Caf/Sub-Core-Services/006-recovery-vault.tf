locals {
  rv-name               = var.override-rv-name == null ? lower("rv-${local.customer-code}-${local.sub-name}-${local.location}") : lower(var.override-rv-name)
  rv-sku                = "Standard"
  rv-storage-mode       = var.override-rv-storage-mode == null ? "GeoRedundant"  : lower(var.override-rv-storage-mode)
  rv-soft-delete        = var.rv-disable-soft-delete == null || false ? true : false
  rv-diagnostics-name   = "${local.rv-name}-diag"
  cross-region-restore  = local.rv-storage-mode == "GeoRedundant" ? true : null
  encryption-key-id     = var.rv-encryption-key-id == null ? toset([]) : toset([var.rv-encryption-key-id])
  identity              = local.encryption-key-id == [] ? toset([]) : toset(["SystemAssigned"])
  default-rv-logs       = ["CoreAzureBackup","AddonAzureBackupJobs","AddonAzureBackupAlerts","AddonAzureBackupPolicy","AddonAzureBackupStorage","AddonAzureBackupProtectedInstance"]
  disabled-rv-logs       = ["AzureBackupReport","AzureSiteRecoveryEvents","AzureSiteRecoveryJobs","AzureSiteRecoveryProtectedDiskDataChurn","AzureSiteRecoveryRecoveryPoints","AzureSiteRecoveryReplicatedItems","AzureSiteRecoveryReplicationDataUploadRate","AzureSiteRecoveryReplicationStats"]
}

resource "azurerm_recovery_services_vault" "rv-core" {
    name                         = local.rv-name
    location                     = azurerm_resource_group.core-services.location
    resource_group_name          = azurerm_resource_group.core-services.name
    sku                          = local.rv-sku
    soft_delete_enabled          = local.rv-soft-delete
    storage_mode_type            = local.rv-storage-mode
    tags                         = local.tags
    cross_region_restore_enabled = local.cross-region-restore

    dynamic "identity" {
      for_each          = local.identity
      content {
        type            = identity.key
      }
    }

    dynamic "encryption" {
      for_each                            = local.encryption-key-id
      content {
        key_id                            = encryption.key
        infrastructure_encryption_enabled = true
        use_system_assigned_identity      = true
      }
    }

    lifecycle {
      ignore_changes = [
        storage_mode_type, sku, tags
      ]
    }
}

# https://docs.microsoft.com/en-us/azure/backup/backup-azure-monitoring-use-azuremonitor

resource "azurerm_monitor_diagnostic_setting" "backupdiagnostics" {
  name                           = local.rv-diagnostics-name
  target_resource_id             = azurerm_recovery_services_vault.rv-core.id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.la-ws-mgmt.id
  log_analytics_destination_type = "Dedicated"

# ENABLED
  dynamic "log" {
    for_each = local.default-rv-logs
    content {
      category = log.value
      enabled  = true
      retention_policy {
        days = 0
        enabled = false
      }
    }
  }
  metric {
    category = "Health"
    enabled  = true
    retention_policy {
      days = 0
      enabled = false
    }    
  }
# Disabled
  dynamic "log" {
    for_each = local.disabled-rv-logs
    content {
      category = log.value
      enabled  = false
      retention_policy {
        days = 0
        enabled = false
      }
    }
  }

}

output "rv-id" {
  value = azurerm_recovery_services_vault.rv-core.id
}