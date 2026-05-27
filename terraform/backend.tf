terraform {
  backend "s3" {
    bucket = "terraform-state-airton-2026"
    key    = "serverless/terraform.tfstate"
    region = "us-east-1"
  }
}