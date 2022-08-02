resource "azurerm_public_ip" "firewall_pip" {
  name                = local.firewall_pip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.firewall_pip_allocation_method
  sku                 = var.firewall_pip_sku
}

resource "azurerm_firewall" "firewall" {
  name                = local.firewall_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.firewall_sku_name
  sku_tier            = var.firewall_sku_tier

  ip_configuration {
    name                 = local.firewall_pip_name
    subnet_id            = var.firewall_subnet_id
    public_ip_address_id = azurerm_public_ip.firewall_pip.id
  }
}