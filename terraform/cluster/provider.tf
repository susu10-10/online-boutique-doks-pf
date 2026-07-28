# This one configures the inside of the cluster
# it installs ArgoCD and creates namespaces using Kubernetes + Helm Terraform provider

terraform {
  required_version = ">= 1.15.0"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.95.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.2.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.2.0"
    }
  }

}

provider "digitalocean" {
  # Token comes from DIGITALOCEAN_TOKEN env var
}

# The data "digitalocean_kubernetes_cluster" block reads the existing cluster by name (boutique-doks). 
# It doesn't create anything. It fetches the kubeconfig, endpoint, and CA cert so the Kubernetes and Helm providers can connect to it. This is how the two stacks chain together

data "digitalocean_kubernetes_cluster" "boutique-cluster" {
  name = "boutique-doks"
}

provider "kubernetes" {
  host                   = data.digitalocean_kubernetes_cluster.boutique-cluster.endpoint
  token                  = data.digitalocean_kubernetes_cluster.boutique-cluster.kube_config[0].token
  cluster_ca_certificate = base64decode(data.digitalocean_kubernetes_cluster.boutique-cluster.kube_config[0].cluster_ca_certificate)
}

provider "helm" {
  kubernetes = {
    host                   = data.digitalocean_kubernetes_cluster.boutique-cluster.endpoint
    token                  = data.digitalocean_kubernetes_cluster.boutique-cluster.kube_config[0].token
    cluster_ca_certificate = base64decode(data.digitalocean_kubernetes_cluster.boutique-cluster.kube_config[0].cluster_ca_certificate)
  }
}