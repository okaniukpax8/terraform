resource "google_compute_instance" "test" {
  name         = "test"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
      size  = 20
      type  = "pd-standard"
    }
  }
  // Local SSD disk
  scratch_disk {
  }

  network_interface {
    network = "${google_compute_network.test.name}"

    access_config {
      // Ephemeral IP
     nat_ip = "${google_compute_address.static.address}"
     
    }
   }

  metadata = {
    foo = "bar"
  }
  
  metadata_startup_script = "sudo apt-get install apache2 -y; sudo rm -rf /var/www/html/index.html; echo Hi DevOps Flow, my IP is $(curl -H 'Metadata-Flavor: Google' http://metadata/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip) | sudo tee --append /var/www/html/index.html; sudo systemctl restart apache2"
  
  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}
resource "google_compute_disk" "test" {
  name  = "test-disk"
  type  = "pd-ssd"
  zone  = "us-central1-a"
  image = "debian-8-jessie-v20170523"
}
 resource "google_compute_attached_disk" "test" {
  disk = "${google_compute_disk.test.name}"
  instance = "${google_compute_instance.test.name}"  
  zone  = "us-central1-a"
}