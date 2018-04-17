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

resource "aws_db_instance" "default" {
  allocated_storage = 10
  storage_type = "gp2"
  engine = "postgres"
  instance_class = "db.t2.micro"
  name = "core"
  port = 5432
  engine_version = "10"

  username = "${var.username}"
  password = "${var.password}"
}

resource "aws_instance" "default" {
  ami = "ami-ac442ac3"
  availability_zone = "eu-central-1a"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  tags {
    Name = "Rule engine application"
    Environment = "Dev"
  }
}

variable "username" {}
variable "password" {}