data "azurerm_client_config" "current" {}

# Container registry
resource "azurerm_container_registry" "acr" {
  name                = "${var.prefix}acr"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
}
  #Test pipeline by this comment

# 4. Key Vault
resource "azurerm_key_vault" "vault" {
  name                = "${var.prefix}-kv"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  public_network_access_enabled = false
}

# Key Vault Access Policy
resource "azurerm_key_vault_access_policy" "app_access" {
  key_vault_id = azurerm_key_vault.vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_container_app.app.identity[0].principal_id
  secret_permissions = ["Get", "List"]
}

# Role for ACR
resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_container_app.app.identity[0].principal_id
}

# Private Endpoint
resource "azurerm_private_endpoint" "sql_pe" {
  name                = "${var.prefix}-sql-pe"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.private_endpoints.id

  private_service_connection {
    name                           = "sql-conn"
    private_connection_resource_id = azurerm_sql_server.sql.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
}