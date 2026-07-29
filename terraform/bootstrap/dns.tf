# ADD domain to DO DNS

resource "digitalocean_domain" "boutique" {
  name = var.domain_name
}

# A record pointing to the LoadBalancer

resource "digitalocean_record" "root" {
  domain = digitalocean_domain.boutique.name
  type   = "A"
  name   = "@"
  ttl    = 300
  value  = var.lb_ip
}

# WildCard CNAME
resource "digitalocean_record" "wildcard" {
  domain = digitalocean_domain.boutique.name
  type   = "CNAME"
  name   = "*"
  ttl    = 60
  value  = "@"
}