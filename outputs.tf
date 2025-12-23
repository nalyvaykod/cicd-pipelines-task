output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.main.name
}

output "container_app_url" {
  description = "Internal FQDN of the application"
  value       = azurerm_container_app.app.latest_revision_fqdn
  #Test pipeline by this comment
}

output "managed_identity_principal_id" {
  description = "ID of the managed identity"
  value       = azurerm_container_app.app.identity[0].principal_id
}   

output "acr_login_server" {
  description = "Login server for Azure Container Registry"
  value       = azurerm_container_registry.acr.login_server
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.vault.vault_uri
}

output "sql_server_fqdn" {
  description = "FQDN of the SQL server"
  value       = azurerm_sql_server.sql.fully_qualified_domain_name
}

output "sql_database_name" {
  description = "Name of the SQL database"
  value       = azurerm_sql_database.db.name
}

output "storage_account_name" {
  description = "Name of the Storage Account for files"
  value       = azurerm_storage_account.files.name
}

output "file_share_name" {
  description = "Name of the File Share"
  value       = azurerm_storage_share.fileshare.name
}