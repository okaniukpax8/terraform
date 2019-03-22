provider "google" {
  credentials = "${file("terraform.json")}"
  project     = "terraform-235208"
  region      = "us-central1"
}
