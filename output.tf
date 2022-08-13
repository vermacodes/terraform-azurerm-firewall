output "firewall_public_ip" {
    description = "Public IP of Firewall"
    value = azurerm_public_ip.firewall_pip.ip_address
}