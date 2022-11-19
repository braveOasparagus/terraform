# create service account & grant permission
module "service_accounts" {
  source        = "terraform-google-modules/service-accounts/google"
  project_id    = var.project_id
  prefix        = var.prefix
  names         = ["sa"]
  project_roles = ["${var.project_id}=>roles/editor"]
}
