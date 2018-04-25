terraform {
  backend "s3" {
    bucket = "s3-terraform-state-backend"
    region = "eu-central-1"
    key = "deploy/terraform.tfstate"
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "deploy" {
  bucket = "deploy-grand-journey-bucket"
  acl = "private"

  tags {
    Name = "Bucket for deployable units"
    Environment = "Dev"
  }
}
