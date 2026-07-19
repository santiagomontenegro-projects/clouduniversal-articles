variable "project_id" {
  description = "ID del proyecto de GCP donde se desplegarán los recursos"
  type        = string
}

variable "region" {
  description = "Región de despliegue"
  type        = string
  default     = "europe-southwest1"
}

variable "bucket_name" {
  description = "Nombre del bucket de Cloud Storage (debe ser único a nivel global)"
  type        = string
}
