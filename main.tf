resource "azurerm_public_ip" "firewall_pip" {
  name                = local.firewall_pip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.firewall_pip_allocation_method
  sku                 = var.firewall_pip_sku
}