# create service account & grant permission
module "service_accounts" {
  source        = "terraform-google-modules/service-accounts/google"
  project_id    = var.project_id
  prefix        = var.prefix
  names         = ["sa"]
  project_roles = ["${var.project_id}=>roles/editor"]
}

# create vpc and subnet 
module "vpc" {
    source  = "terraform-google-modules/network/google"
    version = "~> 4.0"
    project_id   = var.project_id
    network_name = "terraform-vpc"
    routing_mode = "GLOBAL"
    subnets = [
        {
            subnet_name           = "terraform-subnet-01"
            subnet_ip             = "10.10.10.0/24"
            subnet_region         = "us-west1"
        },
        {
            subnet_name           = "terraform-subnet-02"
            subnet_ip             = "10.10.20.0/24"
            subnet_region         = "asia-northeast3"
        }
    ]
    routes = [
        {
            name                   = "egress-internet"
            description            = "route through IGW to access internet"
            destination_range      = "0.0.0.0/0"
            tags                   = "egress-inet"
            next_hop_internet      = "true"
        }
    ]
}


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


# create vm instance on created subnet using the service account 
resource "google_compute_instance" "vm" {
  project      = var.project_id
  name         = "terraform-vm"
  machine_type = "e2-medium"
  zone         = "us-west1-a"
  tags         = ["ssh"]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

metadata_startup_script = "gsutil ls > ~/bucket.txt"
  network_interface {
    network = "terraform-vpc"
    subnetwork = "https://www.googleapis.com/compute/v1/projects/sungwon-int-200421/regions/us-west1/subnetworks/terraform-subnet-01"
    access_config {
      # Include this section to give the VM an external IP address
    }
  }
  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = "${var.prefix}-sa@${var.project_id}.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
}


# create firewall rule to allow ssh vm 
module "firewall_rules" {
  source       = "terraform-google-modules/network/google//modules/firewall-rules"
  project_id   = var.project_id
  network_name = module.vpc.network_name
  rules = [{
    name                    = "allow-ssh-ingress"
    description             = null
    direction               = "INGRESS"
    priority                = null
    ranges                  = ["0.0.0.0/0"]
    source_tags             = null
    source_service_accounts = null
    target_tags             = ["ssh"]
    target_service_accounts = null
    allow = [{
      protocol = "tcp"
      ports    = ["22"]
    }]
    deny = []
    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }]
}



