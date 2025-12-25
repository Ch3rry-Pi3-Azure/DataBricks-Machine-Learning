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
  name = "machine-learning-notebook-pipeline"

  task {
    task_key        = "01_training_model"
    existing_cluster_id = data.terraform_remote_state.compute.outputs.cluster_id
    notebook_task {
      notebook_path = "/Shared/machine-learning/01_training_model.ipynb"
    }
  }

  task {
    task_key        = "02_mlflow"
    existing_cluster_id = data.terraform_remote_state.compute.outputs.cluster_id
    depends_on {
      task_key = "01_training_model"
    }
    notebook_task {
      notebook_path = "/Shared/machine-learning/02_mlflow.ipynb"
    }
  }

  task {
    task_key        = "03_hyperopt"
    existing_cluster_id = data.terraform_remote_state.compute.outputs.cluster_id
    depends_on {
      task_key = "02_mlflow"
    }
    notebook_task {
      notebook_path = "/Shared/machine-learning/03_hyperopt.ipynb"
    }
  }

  task {
    task_key        = "04_deep_learning"
    existing_cluster_id = data.terraform_remote_state.compute.outputs.cluster_id
    depends_on {
      task_key = "03_hyperopt"
    }
    notebook_task {
      notebook_path = "/Shared/machine-learning/04_deep_learning.ipynb"
    }
  }
}
