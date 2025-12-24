variable "resource_group_name" {
  type        = string
  description = "Name of the resource group containing the Databricks workspace"
}

variable "cluster_name" {
  type        = string
  description = "Name of the Databricks cluster"
  default     = "Data Analytics Cluster"
}

variable "data_security_mode" {
  type        = string
  description = "Data security mode for the cluster"
  default     = "DATA_SECURITY_MODE_AUTO"
}

variable "runtime_engine" {
  type        = string
  description = "Runtime engine (e.g., PHOTON)"
  default     = "PHOTON"
}

variable "kind" {
  type        = string
  description = "Cluster kind"
  default     = "CLASSIC_PREVIEW"
}

variable "spark_version" {
  type        = string
  description = "Databricks runtime version"
  default     = "16.4.x-scala2.13"
}

variable "node_type_id" {
  type        = string
  description = "Worker node type ID"
  default     = "Standard_DC4as_v5"
}

variable "autotermination_minutes" {
  type        = number
  description = "Minutes of inactivity before auto-termination"
  default     = 20
}

variable "is_single_node" {
  type        = bool
  description = "Whether to create a single-node cluster"
  default     = true
}
