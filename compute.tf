#Monitoring
resource "azurerm_log_analytics_workspace" "logs" {
  name                = "${var.prefix}-law"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
}

# Container environment
resource "azurerm_container_app_environment" "env" {
  name                           = "${var.prefix}-ca-env"
  location                       = azurerm_resource_group.main.location
  resource_group_name            = azurerm_resource_group.main.name
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.logs.id
  infrastructure_subnet_id       = azurerm_subnet.app.id
  internal_load_balancer_enabled = true
}

# Container app
resource "azurerm_container_app" "app" {
  name                         = "${var.prefix}-backend-app"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  identity { type = "SystemAssigned" }

  template {
    container {
      name   = "backend-container"
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = 0.5
      memory = "1.0Gi"
    }
  }

  ingress {
    external_enabled = false
    target_port      = 8080
    transport        = "auto"

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}
