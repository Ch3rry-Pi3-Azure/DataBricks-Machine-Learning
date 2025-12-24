variable "resource_group_name" {
  type        = string
  description = "Name of the existing resource group"
}

variable "location" {
  type        = string
  description = "Azure region for the workspace (defaults to RG location if null)"
  default     = null
}

variable "workspace_name" {
  type        = string
  description = "Name of the Databricks workspace (must be globally unique). If null, a random animal name is appended."
  default     = null
}

variable "managed_resource_group_name" {
  type        = string
  description = "Name of the managed resource group created by Databricks. If null, uses <workspace_name>_managed."
  default     = null
}

variable "workspace_name_prefix" {
  type        = string
  description = "Prefix used to build the workspace name when workspace_name is null"
  default     = "dbw-databricks-analytics"
}

variable "sku" {
  type        = string
  description = "Databricks workspace tier"
  default     = "premium"
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Enable public network access to the workspace"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the workspace"
  default     = {}
}
