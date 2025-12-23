# SQL Database
resource "azurerm_sql_server" "sql" {
  name                         = "${var.prefix}-sqlserver"
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_sql_database" "db" {
  name                             = "${var.prefix}-sqldb"
  resource_group_name              = azurerm_resource_group.main.name
  location                         = azurerm_resource_group.main.location
  server_name                      = azurerm_sql_server.sql.name
  edition                          = "Basic"
  collation                        = "SQL_Latin1_General_CP1_CI_AS"
  create_mode                      = "Default"
  requested_service_objective_name = "Basic"
}

# Storage for files
resource "azurerm_storage_account" "files" {
  name                          = "${var.prefix}storagedata"
  resource_group_name           = azurerm_resource_group.main.name
  location                      = azurerm_resource_group.main.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  public_network_access_enabled = true
}

resource "azurerm_storage_share" "fileshare" {
  name                 = "user-files"
  storage_account_name = azurerm_storage_account.files.name
  quota                = 50
}
