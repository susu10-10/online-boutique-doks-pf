# namespaces for platform components

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_namespace" "platform" {
  metadata {
    name = "platform"
  }
}

resource "kubernetes_namespace" "boutique" {
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
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  version    = "10.2.1"

  values = [
    file("${path.module}/../../clusters/boutique/argocd/values.yaml")
  ]
  depends_on = [kubernetes_namespace.argocd]
}