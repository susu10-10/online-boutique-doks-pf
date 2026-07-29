# Use existing domain (already registered in DO)
resource "digitalocean_domain" "boutique" {
  name = var.domain_name
}

# A record pointing to the LoadBalancer
resource "digitalocean_record" "root" {
  domain = data.digitalocean_domain.boutique.name
  type   = "A"
  name   = "@"
  ttl    = 60
  value  = var.lb_ip
}

# Wildcard CNAME...
resource "digitalocean_record" "wildcard" {
  domain = data.digitalocean_domain.boutique.name
  type   = "CNAME"
  name   = "*"
  ttl    = 60
  value  = "@"
}