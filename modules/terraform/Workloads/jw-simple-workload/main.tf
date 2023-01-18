locals {
  workload-snet-address = cidrsubnet(var.vnet-address-spaces[0], 1, 0)
  rg-name = "rg-${var.workload-name}"
  vnet-name = "vnet-${var.workload-name}"
  snet-name = "snet-${var.workload-name}"
  snet-nsg-name = "nsg-${local.snet-name}"
  nic-name = "nic-${var.workload-name}"
  vm-name = "vm-${var.workload-name}"
  ipcfg-name = "ipcfg-${var.workload-name}"
  pip-name = "pip-${var.workload-name}"
}

resource "azurerm_resource_group" "workload-rg" {
  name                  = local.rg-name
  location              = var.location
  tags                  = var.tags
}

resource "azurerm_virtual_network" "workload-vnet" {
  name                  = local.vnet-name
  location              = azurerm_resource_group.workload-rg.location
  resource_group_name   = azurerm_resource_group.workload-rg.name
  address_space         = var.vnet-address-spaces
  tags                  = var.tags
}

resource "azurerm_subnet" "workload-snet" {
  name                  = local.snet-name
  resource_group_name   = azurerm_resource_group.workload-rg.name
  virtual_network_name  = azurerm_virtual_network.workload-vnet.name
  address_prefixes      = [local.workload-snet-address]
}

resource "azurerm_network_security_group" "workload-nsg" {
  name                  = local.snet-nsg-name
  location              = azurerm_resource_group.workload-rg.location
  resource_group_name   = azurerm_resource_group.workload-rg.name
  tags                  = var.tags
}

resource "azurerm_subnet_network_security_group_association" "wl-subnet-nsg-association" {
  subnet_id                 = azurerm_subnet.workload-snet.id
  network_security_group_id = azurerm_network_security_group.workload-nsg.id
}

resource "random_password" "wl-admin-password" {
  length           = 16
  special          = true
  override_special = "!#*-_=+[]{}<>:?"
}

resource "azurerm_network_interface" "wl-nic" {
  name                = local.nic-name
  location            = azurerm_resource_group.workload-rg.location
  resource_group_name = azurerm_resource_group.workload-rg.name

  dynamic "ip_configuration" {
    for_each                          = var.vm-public-ip == true ? [1] : [] 
    content {
      name                          = local.ipcfg-name
      subnet_id                     = azurerm_subnet.workload-snet.id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id            = azurerm_public_ip.wl-pip[0].id
    }
  }

  dynamic "ip_configuration" {
    for_each                          = var.vm-public-ip == true ? [] : [1]
    content {
      name                          = local.ipcfg-name
      subnet_id                     = azurerm_subnet.workload-snet.id
      private_ip_address_allocation = "Dynamic"
    }
  }

}

resource "azurerm_network_interface_security_group_association" "wl-nic-nsg-association" {
  network_interface_id      = azurerm_network_interface.wl-nic.id
  network_security_group_id = azurerm_network_security_group.workload-nsg.id
}


resource "azurerm_public_ip" "wl-pip" {
  count               = var.vm-public-ip == true ? 1 : 0
  name                = local.pip-name
  resource_group_name = azurerm_resource_group.workload-rg.name
  location            = azurerm_resource_group.workload-rg.location
  allocation_method   = "Static"
  tags                = var.tags
}

resource "azurerm_windows_virtual_machine" "wl-vm" {
  name                = local.vm-name
  resource_group_name = azurerm_resource_group.workload-rg.name
  location            = azurerm_resource_group.workload-rg.location
  size                = var.vm-size
  admin_username      = "a365admin"
  admin_password      = random_password.wl-admin-password.result
  network_interface_ids = [
    azurerm_network_interface.wl-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}