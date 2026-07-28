# namespaces for platform components

resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_namespace_v1" "platform" {
  metadata {
    name = "platform"
  }
}

resource "kubernetes_namespace_v1" "boutique" {
  metadata {
    name = "boutique"
    labels = {
      "linkerd.io/inject" = "enabled"
    }
  }
}

# Install ArgoCD via Helm
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace_v1.argocd.metadata[0].name
  version    = "10.2.1"

  values = [
    file("${path.module}/../../clusters/boutique/argocd/values.yaml")
  ]
  depends_on = [kubernetes_namespace_v1.argocd]
}