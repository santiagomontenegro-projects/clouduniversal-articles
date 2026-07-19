resource "google_storage_bucket" "test_bucket" {
  name                        = var.bucket_name
  location                    = var.region
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  force_destroy               = true

  versioning {
    enabled = true
  }

  labels = {
    environment = "test"
    purpose     = "terraform-demo"
  }
}
