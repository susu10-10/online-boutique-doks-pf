
terraform {
  backend "s3" {
    bucket = "idp-tf"
    key    = "state/doks-main/terraform.tfstate"
    region = "us-east-1"
    endpoints = {
      s3 = "https://nyc3.digitaloceanspaces.com"
    }

    # to enable native s3 compatible state locking inside the bucket.
    use_lockfile   = true
    use_path_style = true

    # skip validation errors when using Do spaces instead of AWS S3
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_s3_checksum            = true
    skip_region_validation      = true
  }
}