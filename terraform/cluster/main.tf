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
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = kubernetes_namespace_v1.argocd.metadata[0].name
  version          = "10.2.1"
  create_namespace = true

  values     = [file("${path.module}/../../clusters/boutique/argocd/values.yaml")]
  depends_on = [kubernetes_namespace_v1.argocd]

  #optional: Tell argocd to look at the root applicatoin manifest immeditely 

}

# modern approach; letting terraform applies the rootapp to bootstrap everything

resource "kubernetes_manifest" "root_app" {
  manifest = {
    # the trigger, one apply tells argocd to ready the file
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name       = "root-platform-app"
      namespace  = "argocd"
      finalizers = ["resources-finalizer.argocd.argoproj.io"]
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://github.com/susu10-10/online-boutique-doks-pf"
        targetRevision = "HEAD"
        path           = "clusters/boutique/infrastructure-apps"
      }
      destination = {
        server    = "https://kubernetes.default.svc" # deploys directly to the current DOKS cluster
        namespace = "argocd"
      }
      syncPolicy = {
        automated = {
          prune    = true # automatically deletes resources removed from git
          selfHeal = true # automatically overwrites manual cluster configs drifts
        }
        syncOptions = [
          "CreateNamespace=true"
        ]
      }
    }
  }
  depends_on = [helm_release.argocd]
}

#k8s secret to store digital ocean token
resource "kubernetes_secret_v1" "digital_ocean_token" {
  metadata {
    name = "digital-ocean-token"
    namespace = kubernetes_namespace_v1.argocd.metadata[0].name
  }
  type = "Opaque"

  stringData = {
    username = "token"
    password = var.do_token
  }
}

# install ArgoCD Image Updater (Add-on)
resource "helm_release" "argocd_image_updater" {
  name             = "argocd-image-updater"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-image-updater"
  namespace        = kubernetes_namespace_v1.argocd.metadata[0].name
  version          = "0.15.0"
  create_namespace = true

  # give the updater permission to write back to github securely
  set {
    name = "config.secret.github_token"
    value = var.gitops_token
  }
  set {
    name = "config.registries[0].api_url"
    value = "https://registry.digitalocean.com"
  }
  set {
    name = "config.registries[0].username"
    value = "token"
  }
  set {
    name = "config.registries[0].password"
    value = "secret:${kubernetes_secret_v1.digital_ocean_token.metadata[0].name}#password"
  }
  
  depends_on = [helm_release.argocd, kubernetes_secret_v1.digital_ocean_token]
}