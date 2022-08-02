locals {
    firewall_pip_name = (var.firewall_pip_name != null ? var.firewall_pip_name : 
    "${var.names.resource_group_type}-${var.names.product_name}-${var.names.environment}-${var.names.location}-fw-pip")

    firewall_name = (var.firewall_name != null ? var.firewall_name : 
    "${var.names.resource_group_type}-${var.names.product_name}-${var.names.environment}-${var.names.location}-fw")
}