# Creating a VPC 
resource "google_compute_network" "vpc_network" {
  name = var.vpc_name
  auto_create_subnetworks = false
}


# Create Multiple Subnets
resource "google_compute_subnetwork" "i27-ecommerce-subnets" {
  count = length(var.subnets)
  name = var.subnets[count.index].name
  ip_cidr_range = var.subnets[count.index].ip_cidr_range
  region = var.subnets[count.index].subnet_region
  network = google_compute_network.vpc_network.self_link
}


# Create a firewall 
resource "google_compute_firewall" "i27-ecommerce-firewalls" {
  name    = var.firewall_name
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports = [ "80", "8080", "22", "9000" ]
  }

  source_ranges = var.source_ranges
  
}

# # Create Subnetwork for central
# resource "google_compute_subnetwork" "i27-ecommerce-subnets" {
#   name          = "i27-ecommerce-central-subnet"
#   ip_cidr_range = "10.1.0.0/16"
#   region        = "us-central1"
#   network       = google_compute_network.vpc_network.self_link
# }

# # Create Subnetwork for east4
# resource "google_compute_subnetwork" "i27-ecommerce-subnets" {
#   name          = "i27-ecommerce-east4-subnet"
#   ip_cidr_range = "10.2.0.0/16"
#   region        = "us-east4"
#   network       = google_compute_network.vpc_network.self_link
#   #network = var.vpc_name
#   #depends_on = [ google_compute_network.vpc_network ] # meta argument
# }

# # Create Subnetwork for asia-south1
# resource "google_compute_subnetwork" "i27-ecommerce-subnets" {
#   name          = "i27-ecommerce-mumbai-subnet"
#   ip_cidr_range = "10.3.0.0/16"
#   region        = "asia-south1"
#   network       = google_compute_network.vpc_network.self_link
# }