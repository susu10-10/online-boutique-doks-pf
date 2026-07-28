output "cluster_id" {
  description = "DOKS Cluster ID"
  value       = digitalocean_kubernetes_cluster.boutique-cluster.id
}

output "cluster_endpoint" {
  description = "DOKS Cluster Endpoint"
  value       = digitalocean_kubernetes_cluster.boutique-cluster.endpoint
}

output "cluster_name" {
  description = "DOKS Cluster Name"
  value       = digitalocean_kubernetes_cluster.boutique-cluster.name
}

output "kubeconfig" {
  description = "Full DOKS Cluster Kubeconfig (sensitive)"
  value       = digitalocean_kubernetes_cluster.boutique-cluster.kube_config[0].raw_config
  sensitive   = true
}

output "cluster_ca_cert" {
  description = "DOKS Cluster CA Certificate"
  value       = digitalocean_kubernetes_cluster.boutique-cluster.kube_config[0].cluster_ca_certificate
  sensitive   = true
}