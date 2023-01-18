output "root-mg-id" {
  value = azurerm_management_group.customer_parent.id
}
output "platform-mg-id" {
  value = azurerm_management_group.platform_parent.id
}
output "management-mg-id" {
  value = azurerm_management_group.management.id
}
output "connectivity-mg-id" {
  value = azurerm_management_group.connectivity.id
}
output "identity-mg-id" {
  value = azurerm_management_group.identity.id
}
output "workloads-mg-id" {
  value = azurerm_management_group.workloads.id
}
output "shared-mg-id" {
  value = azurerm_management_group.shared.id
}
output "sandbox-mg-id" {
  value = azurerm_management_group.sandbox.id
}
output "unmanaged-mg-id" {
  value = azurerm_management_group.unmanaged.id
}
