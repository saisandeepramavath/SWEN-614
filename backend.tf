terraform {
  backend "s3" {
    bucket = "ssr-terraform-wp-bucket"
    key    = "backend.tfstate"
    region = "us-east-1"
  }
}