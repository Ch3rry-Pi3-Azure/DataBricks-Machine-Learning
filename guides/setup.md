# Project Setup Guide

This project provisions Azure resources for Databricks using Terraform and includes helper scripts.

## Prerequisites
- Azure CLI (`az`) installed and authenticated
- Terraform installed (>= 1.5)
- Python (for running the helper scripts)

## Terraform Setup
Check if Terraform is installed and on PATH:

```powershell
terraform version
```

If you need to install or update Terraform on Windows, use one of these:

```powershell
winget install HashiCorp.Terraform
```

```powershell
choco install terraform -y
```

After installing, re-open PowerShell and re-run `terraform version`.

## Azure CLI
Check your Azure CLI and login status:

```powershell
az --version
az login
az account show
```

## Project Structure
- `terraform/01_resource_group`: Azure resource group
- `terraform/02_databricks`: Azure Databricks workspace
- `terraform/03_databricks_compute`: Databricks cluster (compute)
- `terraform/04_notebooks`: Databricks notebooks
- `terraform/05_jobs`: Databricks job to run notebooks
- `scripts/`: Helper scripts to deploy/destroy Terraform resources
- `data/`: Project data files
- `notebooks/`: Jupyter notebooks (`.ipynb`)

## Configure Terraform
Edit `terraform/01_resource_group/terraform.tfvars` to set the resource group name and location:

```hcl
resource_group_name = "rg-databricks-analytics-dev"
location            = "eastus"
```

Edit `terraform/02_databricks/terraform.tfvars` to set Databricks inputs:

```hcl
resource_group_name           = "rg-databricks-analytics-dev"
location                      = "eastus"
workspace_name_prefix         = "dbw-databricks-analytics"
public_network_access_enabled = true
```

If `workspace_name` is not provided, a random animal name is appended to the prefix. The managed resource group name will follow the same pattern with `_managed` appended.

Edit `terraform/03_databricks_compute/terraform.tfvars` to set compute inputs:

```hcl
resource_group_name = "rg-databricks-analytics-dev"
```

Edit `terraform/04_notebooks/terraform.tfvars` to set notebook inputs:

```hcl
resource_group_name = "rg-databricks-analytics-dev"
```

Edit `terraform/05_jobs/terraform.tfvars` to set job inputs:

```hcl
resource_group_name = "rg-databricks-analytics-dev"
```

## Unity Catalog Notes
- Notebooks use widgets to select the Unity Catalog `CATALOG`, `SCHEMA`, and `VOLUME`.
- The catalog must already exist in your metastore; if it does not, create it in the Databricks UI (or provide a managed location).
- The notebooks create the schema and volume if missing, then use `BASE = dbfs:/Volumes/<CATALOG>/<SCHEMA>/<VOLUME>` for all paths.

## Deploy Resources
From the repo root or `scripts/` folder, run:

```powershell
python scripts\deploy.py
```

This runs `terraform init` and `terraform apply` against `terraform/01_resource_group`, `terraform/02_databricks`, `terraform/03_databricks_compute`, `terraform/04_notebooks`, and `terraform/05_jobs` in order.

Optional flags:

```powershell
python scripts\deploy.py --rg-only
python scripts\deploy.py --databricks-only
python scripts\deploy.py --compute-only
python scripts\deploy.py --notebooks-only
python scripts\deploy.py --jobs-only
```

## Destroy Resources
To tear down resources:

```powershell
python scripts\destroy.py
```

Optional flags:

```powershell
python scripts\destroy.py --rg-only
python scripts\destroy.py --databricks-only
python scripts\destroy.py --compute-only
python scripts\destroy.py --notebooks-only
python scripts\destroy.py --jobs-only
```

## Running the Job
After deploying the jobs stack, run the pipeline from the Databricks UI:
- Workspace → Jobs & Pipelines → `data-analytics-notebook-pipeline` → Run now

## Notes
- Resource group names must be unique within your Azure subscription.
- Follow a consistent naming convention (e.g., `rg-databricks-analytics-dev-eastus`).
- Azure Databricks creates a separate managed resource group in the same subscription.
