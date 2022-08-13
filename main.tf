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

resource "azurerm_firewall_network_rule_collection" "network_rules_collection" {
  
  depends_on = [azurerm_firewall.firewall]

  for_each            = var.firewall_network_rules
  name                = each.value["name"]
  resource_group_name = var.resource_group_name
  azure_firewall_name = azurerm_firewall.firewall.name
  priority            = each.value["priority"]
  action              = each.value["action"]

  dynamic "rule" {
    for_each = coalesce(lookup(each.value, "rules"), [])
    content {
      name                  = rule.value.name
      description           = rule.value.description
      source_addresses      = rule.value.source_addresses
      destination_ports     = rule.value.destination_ports
      destination_addresses = rule.value.destination_addresses
      protocols             = rule.value.protocols
    }
  }
}

resource "azurerm_firewall_nat_rule_collection" "nat_rule_collection" {

  depends_on = [azurerm_firewall.firewall]

  for_each            = var.firewall_nat_rules
  name                = each.value["name"]
  resource_group_name = var.resource_group_name
  azure_firewall_name = azurerm_firewall.firewall.name
  priority            = each.value["priority"]
  action              = "Dnat"

  dynamic "rule" {
    for_each = coalesce(lookup(each.value, "rules"), [])
    content {
      name                  = rule.value.name
      description           = rule.value.description
      source_addresses      = rule.value.source_addresses
      destination_ports     = rule.value.destination_ports
      destination_addresses = list(lookup(azurerm_public_ip.firewall_pip, each.value["firewall_key"])["ip_address"])
      protocols             = rule.value.protocols
      translated_address    = rule.value.translated_address
      translated_port       = rule.value.translated_port
    }
  }
}

resource "azurerm_firewall_application_rule_collection" "app_rules_collection" {
  depends_on = [ azurerm_firewall.firewall ]

  for_each            = var.firewall_application_rules
  name                = each.value["name"]
  resource_group_name = var.resource_group_name
  azure_firewall_name = azurerm_firewall.firewall.name
  priority            = each.value["priority"]
  action              = each.value["action"]

  dynamic "rule" {
    for_each = coalesce(lookup(each.value, "rules"), [])
    content {
      name             = rule.value.name
      source_addresses = rule.value.source_addresses
      #fqdn_tags        = lookup(rule.value, "target_fqdns", null) == null && lookup(rule.value, "fqdn_tags", null) != null ? rule.value.fqdn_tags : []
      target_fqdns     = lookup(rule.value, "fqdn_tags", null) == null && lookup(rule.value, "target_fqdns", null) != null ? rule.value.target_fqdns : []

      dynamic "protocol" {
        #for_each = lookup(rule.value, "target_fqdns", null) != null && lookup(rule.value, "fqdn_tags", null) == null ? lookup(rule.value, "protocol", []) : []
        for_each = lookup(rule.value, "target_fqdns", null) != null ? lookup(rule.value, "protocol", []) : []
        content {
          port = lookup(protocol.value, "port", null)
          type = protocol.value.type
        }
      }
    }
  }
}
