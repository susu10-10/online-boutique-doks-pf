terraform {
  required_version = ">= 1.15.0"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.95.0"
    }
  }
}


provider "digitalocean" {
  # Token comes from DIGITALOCEAN_TOKEN env var
}
