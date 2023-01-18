locals {
  # private-dns-objects = [
  #   {
  #     name = "aprivatednszone.net"
  #     arecords = [
  #       {
  #         name = "www"
  #         ttl = 300
  #         records = ["10.0.180.17"]
  #       }
  #     ]
  #     aaaarecord = [
  #       {
  #         name = "wwwv6"
  #         ttl = 300
  #         records = ["fd5d:70bc:930e:d008:0000:0000:0000:7334"]
  #       }
  #     ]
  #   },
  #   {
  #     name = "anotherprivatednszone.net"
  #     arecords = [
  #       {
  #         name = "www"
  #         ttl = 300
  #         records = ["10.0.180.20"]
  #       }
  #     ]
  #     aaaarecord = [
  #       {
  #         name = "wwwv6"
  #         ttl = 300
  #         records = ["fd5d:70bc:930e:d008:0000:0000:0000:7335"]
  #       }
  #     ]
  #   }
  # ]
  # private-dns-zones = [for dns in local.private-dns-objects : dns.name]
  # private-dns-arecords = {for dns in local.private-dns-objects : dns.name => dns.arecords}
  private-dns-zones = toset(var.private-dns-zones)
}

resource "azurerm_private_dns_zone" "hub_private_dns" {
  for_each            = local.private-dns-zones
  name                = each.key
  resource_group_name = azurerm_resource_group.hub-net.name
  tags                = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "hub_private_dns_vnet_link" {
  for_each = local.private-dns-zones
  name                  = "pdns-link-${join("-",split(".",each.key))}"
  resource_group_name   = azurerm_resource_group.hub-net.name
  private_dns_zone_name = azurerm_private_dns_zone.hub_private_dns[each.key].name
  virtual_network_id    = azurerm_virtual_network.hub-vnet.id
  tags                  = local.tags
}


# resource "azurerm_private_dns_a_record" "hub_private_dns_a" {
#   for_each            = local.private-dns-arecords
#   name                = each.value.name
#   zone_name           = azurerm_private_dns_zone.hub_private_dns[each.key].name
#   resource_group_name = azurerm_resource_group.hub-net.name
#   ttl                 = each.value.ttl
#   records             = each.value.records
# }