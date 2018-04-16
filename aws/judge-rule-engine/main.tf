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

resource "aws_instance" "judge-rule-engine" {
  ami = "ami-ac442ac3"
  instance_type = "t2.micro"
  tags {
    Name = "Judge Rule Engine"
    Environment = "Dev"
  }
}
