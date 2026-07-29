data "digitalocean_kubernetes_versions" "vk8s" {
  version_prefix = "1.35."
}

data "digitalocean_project" "idpprj" {
  name = "idp project"
}

resource "digitalocean_kubernetes_cluster" "boutique-cluster" {
  name         = "boutique-doks"
  region       = var.region
  auto_upgrade = false
  registry_integration = true
  version      = data.digitalocean_kubernetes_versions.vk8s.latest_version

  node_pool {
    name       = "worker-pool"
    size       = var.node_size
    node_count = 1
  }

  maintenance_policy {
    start_time = "04:00"
    day        = "sunday"
  }
}


resource "digitalocean_project_resources" "boutique" {
  project = data.digitalocean_project.idpprj.id
  resources = [
    digitalocean_kubernetes_cluster.boutique-cluster.urn
  ]
}