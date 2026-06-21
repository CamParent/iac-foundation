resource "azurerm_private_endpoint" "this" {
  name                = "pe-${var.service_name}-${var.prefix}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-${var.service_name}-${var.prefix}-${var.environment}"
    private_connection_resource_id = var.private_connection_resource_id
    subresource_names              = var.subresource_names
    is_manual_connection           = false
  }

  dynamic "private_dns_zone_group" {
    for_each = length(var.private_dns_zone_ids) > 0 ? [1] : []

    content {
      name                 = "dns-zone-group-${var.service_name}"
      private_dns_zone_ids = var.private_dns_zone_ids
    }
  }

  tags = {
    environment = var.environment
    managed_by  = "terraform"
    service     = var.service_name
  }
}

resource "azurerm_private_dns_zone" "this" {
  for_each = length(var.private_dns_zone_ids) == 0 ? toset([
    "privatelink.database.windows.net"
  ]) : toset([])

  name                = each.value
  resource_group_name = var.resource_group_name

  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each = azurerm_private_dns_zone.this

  name                  = "dns-link-${var.service_name}-${var.environment}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = each.value.name
  virtual_network_id    = var.subnet_id
  registration_enabled  = false

  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}