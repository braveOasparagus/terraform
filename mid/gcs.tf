# create gcs bucket
module "bucket" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "~> 1.3"
  name       = var.bucket_name
  project_id = var.project_id
  location   = "us-east1"
  iam_members = [{
    role   = "roles/storage.objectViewer"
    member = "user:sungwon@mz.co.kr"
  }]
}
