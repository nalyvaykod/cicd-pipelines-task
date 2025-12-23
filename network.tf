#Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-rg-main"
  location = var.location
}

#Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  #Test pipeline by this comment
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

#Subnets
resource "azurerm_subnet" "app" {
  name                 = "app-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/23"]


}

resource "azurerm_subnet" "private_endpoints" {
  name                 = "pe-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  #Test pipeline by this comment

  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

#Private DNS Zone
resource "azurerm_private_dns_zone" "sql_dns" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_private_dns_zone" "storage_dns" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = azurerm_resource_group.main.name
}
  #Test pipeline by this comment

resource "azurerm_private_dns_zone" "acr_dns" {
  name                = "privatelink.azurecr.io"
  resource_group_name = azurerm_resource_group.main.name
}

#Link DNS Zones
resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  count               = 3
  name                = "vnet-link-${count.index}"
  resource_group_name = azurerm_resource_group.main.name
  private_dns_zone_name = element([
    azurerm_private_dns_zone.sql_dns.name,
    azurerm_private_dns_zone.storage_dns.name,
    azurerm_private_dns_zone.acr_dns.name
  ], count.index)
  virtual_network_id   = azurerm_virtual_network.vnet.id
  registration_enabled = false
}
  #Test pipeline by this comment


