output "job_id" {
  value = databricks_job.notebook_pipeline.id
}

output "job_name" {
  value = databricks_job.notebook_pipeline.name
}
