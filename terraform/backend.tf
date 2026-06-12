terraform {
  backend "s3" {
    bucket = "terraform-state"
    key    = "homelab-k3s/terraform.tfstate"
    region = "us-east-1"

    endpoints = {
      s3 = "https://s3-api.klore.net"
    }

    use_path_style              = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
  }
}