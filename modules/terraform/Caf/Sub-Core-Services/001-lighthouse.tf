# Lighthouse Locals

locals {
  lh-namedef = var.override-lh-namedef == null ? "advanced-${local.customer-code}-lh-${local.sub-name}" : lower(var.override-lh-namedef)
  lh-description = var.override-lh-description == null ? "Advanced Lighthouse Definition for ${local.sub-name} subscription" : var.override-lh-description
  lh-mtenant-id = var.override-lh-mtenant-id == null ? "2b5a89e7-01bf-42ed-9da1-669d82eec17a" : lower(var.override-lh-mtenant-id)
  lh-scope = var.override-lh-scope == null ? data.azurerm_subscription.current.id : lower(var.override-lh-scope)
  lh-assign-scope = var.override-lh-assign-scope == null ? local.lh-scope : lower(var.override-lh-assign-scope)
  lh-authorization = var.override-lh-authorization == null ? local.default-lh-authorization : var.override-lh-authorization
  default-lh-authorization = [
        {
            principal-id           = "89967ed7-4605-4c60-be5a-eaea9e74441e"
            principal-display-name = "Azure Engineering"
            role-def-id            = "b24988ac-6180-42a0-ab88-20f7382dd24c" // Contributor
        },
        {
            principal-id            = "40968880-5290-40b2-9b79-52291592ae00"
            role-def-id             = "acdd72a7-3385-48ef-bd42-f606fba81ae7" // Reader
            principal-display-name  = "Account Management Reader"
        }
  ]
}



# Lighthouse Definition

resource "azurerm_lighthouse_definition" "lighthouse-definition" {
name                                        = local.lh-namedef
description                                 = local.lh-description
managing_tenant_id                          = local.lh-mtenant-id
scope                                       = local.lh-scope

     dynamic "authorization" {
     for_each                         =   local.lh-authorization[*]
     
     content {
        principal_id                  = authorization.value.principal-id
        role_definition_id            = authorization.value.role-def-id
        delegated_role_definition_ids = try(authorization.value.delegated-role-def-ids, null)
        principal_display_name        = try(authorization.value.principal-display-name, null)
     }
    }
}


resource "azurerm_lighthouse_assignment" "lighthouse-assignment" {
  scope                     = local.lh-assign-scope
  lighthouse_definition_id  = azurerm_lighthouse_definition.lighthouse-definition.id
}