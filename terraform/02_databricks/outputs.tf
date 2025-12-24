output "databricks_workspace_id" {
  value = azurerm_databricks_workspace.main.id
}

output "databricks_workspace_url" {
  value = azurerm_databricks_workspace.main.workspace_url
}

output "databricks_workspace_name" {
  value = azurerm_databricks_workspace.main.name
}

output "managed_resource_group_name" {
  value = azurerm_databricks_workspace.main.managed_resource_group_name
}
