terraform {
  required_version = ">= 1.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.48"
    }
  }
}

provider "azurerm" {
  features {}
}

data "terraform_remote_state" "databricks" {
  backend = "local"
  config = {
    path = "../02_databricks/terraform.tfstate"
  }
}

data "terraform_remote_state" "compute" {
  backend = "local"
  config = {
    path = "../03_databricks_compute/terraform.tfstate"
  }
}

data "azurerm_databricks_workspace" "main" {
  name                = data.terraform_remote_state.databricks.outputs.databricks_workspace_name
  resource_group_name = var.resource_group_name
}

provider "databricks" {
  host                        = data.azurerm_databricks_workspace.main.workspace_url
  azure_workspace_resource_id = data.azurerm_databricks_workspace.main.id
  auth_type                   = "azure-cli"
}

resource "databricks_job" "notebook_pipeline" {
  name = "data-analytics-notebook-pipeline"

  task {
    task_key        = "01_data_ingest"
    existing_cluster_id = data.terraform_remote_state.compute.outputs.cluster_id
    notebook_task {
      notebook_path = "/Shared/data-analytics/01_data_ingest.ipynb"
    }
  }

  task {
    task_key        = "02_dataframe_schema"
    existing_cluster_id = data.terraform_remote_state.compute.outputs.cluster_id
    depends_on {
      task_key = "01_data_ingest"
    }
    notebook_task {
      notebook_path = "/Shared/data-analytics/02_dataframe_schema.ipynb"
    }
  }

  task {
    task_key        = "03_sql_analysis"
    existing_cluster_id = data.terraform_remote_state.compute.outputs.cluster_id
    depends_on {
      task_key = "02_dataframe_schema"
    }
    notebook_task {
      notebook_path = "/Shared/data-analytics/03_sql_analysis.ipynb"
    }
  }

  task {
    task_key        = "04_visualization"
    existing_cluster_id = data.terraform_remote_state.compute.outputs.cluster_id
    depends_on {
      task_key = "03_sql_analysis"
    }
    notebook_task {
      notebook_path = "/Shared/data-analytics/04_visualization.ipynb"
    }
  }
}
