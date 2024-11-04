provider "google" {
  credentials = file(var.crendital-file)
  project = var.provider-project
  region  = var.provider-region
  zone    = var.provider-zone
}

resource "google_compute_instance" "default" {
  name         = var.vm-name 
  machine_type = var.vm-machine_type
  zone         = var.provider-zone      

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


