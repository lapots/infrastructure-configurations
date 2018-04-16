terraform {
  backend "s3" {
    bucket = "s3-terraform-state-backend"
    region = "eu-central-1"
    key = "judge-rule-engine/terraform.tfstate"
  }
}

provider "aws" {
  region = "eu-central-1"
}

# should contain only instance configuration in the future
