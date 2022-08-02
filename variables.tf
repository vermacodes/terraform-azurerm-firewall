variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "names" {
  description = "Names to be applied to resources."
  type        = map(string)
  default     = null
}

variable "firewall_name" {
  description = "Firewall name"
  type        = string
  default     = null # defaulted to null to create name based on names metadata
}

variable "firewall_pip_name" {
  description = "Firewall Public IP name"
  type        = string
  default     = null # defaulted to null to create name based on names metadata
}

variable "tags" {
  description = "Tags to be applied to resources."
  type        = map(string)
}

variable "firewall_sku_name" {
  description = "Firewall SKU Name"
  type        = string
  default     = "AZFW_VNet"

  validation {
    condition = (
      var.firewall_sku_name == "AZFW_VNet" ||
      var.firewall_sku_name == "AZFW_Hub"
    )
    error_message = "Firewall SKU wrong. Possible values are 'AZFW_Hub' and 'AZFW_VNet'"
  }
}

variable "firewall_sku_tier" {
  description = "Firewall SKU Tier"
  type        = string
  default     = "Standard"

  validation {
    condition = (
      var.firewall_sku_tier == "Standard" ||
      var.firewall_sku_tier == "Premium"
    )
    error_message = "SKU tier of the Firewall is set wrong. Possible values are 'Premium' and 'Standard'"
  }
}

variable "firewall_subnet_id" {
  description = "AzureFirewallSubnet ID"
  type        = string
}

variable "firewall_pip_allocation_method" {
  description = "Firewall Public IP allocation method"
  type        = string
  default     = "Static"

  validation {
    condition = (
      var.firewall_pip_allocation_method == "Static" ||
      var.firewall_pip_allocation_method == "Dynamic"
    )
    error_message = "Firewall Public IP allocatio method must be one of 'Static' or 'Dynamic'"
  }
}

variable "firewall_pip_sku" {
  description = "Firewall public IP SKU"
  type        = string
  default     = "Standard"

  validation {
    condition = (
      var.firewall_pip_sku == "Standard" ||
      var.firewall_pip_sku == "Basic"
    )
    error_message = "Firewall pubic IP can be of 'Standard' or 'Basic' type."
  }
}
