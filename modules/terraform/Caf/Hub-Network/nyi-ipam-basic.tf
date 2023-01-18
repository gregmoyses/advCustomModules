# locals {
#   ipam-regional-address-spaces = var.azure-region-address-spaces
#   first-network = local.ipam-regional-address-spaces[0]
#   first-network-id = split("/", local.first-network)[0]
#   first-network-prefix = split("/", local.first-network)[1]
#   ipam-hub-vnet-size = 24
#   ipam-hub-vnet-bit-diff = local.ipam-hub-vnet-size - parseint(local.first-network-prefix, 10)
#   ipam-hub-vnet-map = [{
#     name = "hub-vnet"
#     new_bits = local.ipam-hub-vnet-bit-diff
#   }]
#   ipam-workloads = {} # This could form a method of workload vnet management
#   ipam-workloads-list = [
#     for wlk, wlv in local.ipam-workloads : 
#       {
#         name = wlk
#         new_bits = wlv - parseint(local.first-network-prefix, 10)
#       }
#   ]
#   ipam-networks-list = concat(local.ipam-hub-vnet-map, local.ipam-workloads-list)
#   ipam-hub-snets = [
#     {
#       name = "AzureFirewallSubnet"
#       new_bits = 2
#     },
#     {
#       name = "GatewaySubnet"
#       new_bits = 2
#     },
#     {
#       name = "AzureBastionSubnet"
#       new_bits = 2
#     }
#   ]
# }

# module "vnet_addrs" {
#   source = "hashicorp/subnets/cidr"
#   base_cidr_block = local.first-network
#   networks = local.ipam-networks-list
# }

# module "hub_snets" {
#   source = "hashicorp/subnets/cidr"
#   base_cidr_block = module.vnet_addrs.network_cidr_blocks["hub-vnet"]
#   networks = local.ipam-networks-list
# }

# output "ipam-vnets" {
#   value = module.vnet_addrs.network_cidr_blocks
# }
# # Bastion /26 or larger

# # Gateway /27 or larger /26 probs

# # Firewall /26 or larger