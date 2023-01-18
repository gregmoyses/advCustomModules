resource "azurerm_resource_group" "rg" {
        name      = var.custom-rg-name == null ? "rg-${var.rg-suffix}" : var.custom-rg-name
        location  = var.rg-location
        tags      = var.tags
}

# testing the batch trigger in azure devops pipelines