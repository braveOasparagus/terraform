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

metadata_startup_script = "sudo apt-get install -y nginx"
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
