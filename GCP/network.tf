resource "google_compute_network" "test" {
  name = "my-network"
  
}

resource "google_compute_subnetwork" "test" {
  name          = "my-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
  network       = "${google_compute_network.test.name}"
}

resource "google_compute_address" "static" {
  name = "ipv4-address"
}