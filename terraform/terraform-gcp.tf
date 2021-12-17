############
# provider #
############
provider "google" {
  credentials = file("../credentials/.gcp-creds.json")

  project = var.GCP_PROJECT
  region  = var.GCP_REGION
  zone    = var.GCP_ZONE
}

#############
# variables #
#############
variable "ssh_key_file_name" {
  default = "../credentials/.gcp_ssh.pub"
}

variable "ssh_user_name" {
  default = "gcp_k8s"
}

variable "GCP_ZONE" {
  type = string
}

variable "GCP_REGION" {
  type = string
}

variable "GCP_PROJECT" {
  type = string
}

#############
# instances #
#############
resource "google_compute_instance" "k8s-master" {
  name         = "k8s-master"
  machine_type = "e2-small"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      type  = "pd-standard"
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_user_name}:${file(var.ssh_key_file_name)}"
  }

  labels = {
    service_name = "k8s"
    service_role = "master"
  }

  tags = ["k8s"]

  network_interface {
    network = "default"
    access_config {
      nat_ip       = google_compute_address.k8s-master.address
      network_tier = "STANDARD"
    }
  }
}

resource "google_compute_instance" "k8s-node1" {
  name         = "k8s-node1"
  machine_type = "e2-small"
  allow_stopping_for_update = true 

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      type  = "pd-standard"
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_user_name}:${file(var.ssh_key_file_name)}"
  }

  labels = {
    service_name = "k8s"
    service_role = "node"
  }

  network_interface {
    network = "default"
    access_config {
      network_tier = "STANDARD"
    }
  }
}


#########
# rules #
#########
resource "google_compute_firewall" "allow-posgtres" {
  name    = "allow-posgtres"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["6443"]
  }
  target_tags   = ["k8s"]
  source_ranges = ["0.0.0.0/0"]
}

#############
# addresses #
#############
resource "google_compute_address" "k8s-master" {
  region       = var.GCP_REGION
  name         = "k8s-master"
  address_type = "EXTERNAL"
  network_tier = "STANDARD"
}