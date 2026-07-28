variable "gitops_token" {
  description = "GitHub personal access token with repo write access"
  type        = string
  sensitive = true
}

variable "do_token" {
  description = "Digital Ocean personal access token"
  type        = string
  sensitive = true
}