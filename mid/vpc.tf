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
