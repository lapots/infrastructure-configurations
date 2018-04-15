terraform {
  backend "s3" {
    bucket = "s3-terraform-state-backend"
    region = "eu-central-1"
    key = "terraform.tfstate"
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "mvn_repo" {
  bucket = "repo.mvn.dev"
  acl = "private"

  tags {
    Name = "Maven artifactory bucket"
    Environment = "Dev"
  }
}
