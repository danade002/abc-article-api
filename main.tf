provider "google" {
  version = "3.33.0"
  project = "GloverTest"
  region  = "europe-west1"
}

resource "google_container_registry" "gcr_repository" {
  name = "abc-article-api"
}

resource "google_container_cluster" "gke_cluster" {
  name               = "glovertest"
  location           = google_container_registry.gcr_repository.location
  initial_node_count = 1

  node_config {
    machine_type = "n1-standard-1"
  }
}

resource "google_container_node_pool" "gke_nodepool" {
  name               = "abc-glover"
  location           = google_container_cluster.gke_cluster.location
  cluster            = google_container_cluster.gke_cluster.name
  initial_node_count = 1

  node_config {
    machine_type = "n1-standard-1"
  }
}

resource "google_container_service" "gke_service" {
  name       = "devops-article-api"
  location   = google_container_cluster.gke_cluster.location
  cluster    = google_container_cluster.gke_cluster.name
  image      = "${google_container_registry.gcr_repository.name}/devops-article-api:latest"
  port_map {
    abc-article-api = 5001
  }
}
