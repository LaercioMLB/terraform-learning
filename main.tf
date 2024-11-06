provider "google" {
  credentials = file(var.crendital-file)
  project = var.provider-project
  region  = var.provider-region
  zone    = var.provider-zone
}

#Regra de firewall para permitir tráfego nas portas desejadas
resource "google_compute_firewall" "allow_http_https_custom" {
  name    = var.resource-firewall-name
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]  #Verifique se pode deixar para qualquer um acessar
  target_tags   = ["http-server", "https-server", "custom-server"]
}

resource "google_compute_instance" "default" {
  name         = var.vm-name 
  machine_type = var.vm-machine_type
  zone         = var.provider-zone      

  boot_disk {
    initialize_params {
      image = "ubuntu-2204-lts"
      size = 50
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
  tags = ["http-server", "https-server", "custom-server"]
}