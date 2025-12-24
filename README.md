# Databricks Data Analytics (Azure)

Terraform-driven Databricks analytics project on Microsoft Azure. This repo provisions:
- Azure resource group
- Azure Databricks workspace
- Databricks compute cluster
- Notebook uploads to `/Shared/data-analytics`
- A Databricks job pipeline that runs the notebooks in order

## Quick Start
1) Install prerequisites:
   - Azure CLI (`az`)
   - Terraform (>= 1.5)
   - Python

2) Authenticate to Azure:
```powershell
az login
az account show
```

3) Configure Terraform inputs:
```text
terraform/01_resource_group/terraform.tfvars
terraform/02_databricks/terraform.tfvars
terraform/03_databricks_compute/terraform.tfvars
terraform/04_notebooks/terraform.tfvars
terraform/05_jobs/terraform.tfvars
```

4) Deploy everything:
```powershell
python scripts\deploy.py
```

## Project Structure
- `terraform/01_resource_group`: Azure resource group
- `terraform/02_databricks`: Databricks workspace (premium SKU, managed RG)
- `terraform/03_databricks_compute`: Databricks compute cluster
- `terraform/04_notebooks`: Upload notebooks to Databricks
- `terraform/05_jobs`: Databricks job pipeline
- `notebooks/`: Jupyter notebooks (.ipynb)
- `data/`: CSV data used by the notebooks
- `scripts/`: Deploy/destroy helpers
- `guides/setup.md`: Detailed setup guide

## Deploy/Destroy Options
Use targeted deploys if needed:
```powershell
python scripts\deploy.py --rg-only
python scripts\deploy.py --databricks-only
python scripts\deploy.py --compute-only
python scripts\deploy.py --notebooks-only
python scripts\deploy.py --jobs-only
```

Destroy:
```powershell
python scripts\destroy.py
```

## Unity Catalog Notes
- Notebooks use widgets to select `CATALOG`, `SCHEMA`, and `VOLUME`.
- The catalog must already exist (create it in the Databricks UI if required).
- The notebooks create the schema and volume if missing, then use `BASE = dbfs:/Volumes/<CATALOG>/<SCHEMA>/<VOLUME>` for all paths.

## Run the Pipeline
After deploying the jobs stack:
- Databricks UI → Jobs & Pipelines → `data-analytics-notebook-pipeline` → Run now

## Tips
- Databricks provider requires 64-bit Terraform on Windows.
- Re-deploying notebooks overwrites the workspace copies under `/Shared/data-analytics`.

## Guide
See `guides/setup.md` for detailed instructions.
