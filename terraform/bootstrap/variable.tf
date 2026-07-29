variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "nyc3"
}
variable "domain_name" {
  description = "Domain name"
  type        = string
  default     = "suworks.me"
}

variable "do_spaces_access_key" {
  description = "DigitalOcean Spaces Access Key"
  type        = string
  sensitive   = true
}

variable "do_spaces_secret_key" {
  description = "DigitalOcean Spaces Secret Key"
  type        = string
  sensitive   = true
}


variable "vpc_cidr" {
  description = "CIDR Block for VPC Network"
  type        = string
  default     = "10.111.0.0/20"
}

variable "node_size" {
  description = "Size of the node pool"
  type        = string
  default     = "s-4vcpu-8gb"
}

variable "lb_ip" {
  description = "Load Balancer IP from nginx-ingress"
  type        = string
}