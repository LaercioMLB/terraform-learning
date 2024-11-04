provider "google" {
  credentials = file("gcp-crendentials-laercio-lab.json")
  project = "superb-blend-439623-u5"
  region  = "us-cemtral1"
  zone    = "us-central1-a"
}

resource "google_compute_instance" "default" {
  name         = "terraform-openvpn" 
  machine_type = "e2-medium"
  zone         = "us-central1-a"      

  boot_disk {
    initialize_params {
      image = "ubuntu-minimal-2210-kinetic-amd64-v20230126"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}


