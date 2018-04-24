terraform {
  backend "s3" {
    bucket = "s3-terraform-state-backend"
    region = "eu-central-1"
    key = "db/terraform.tfstate"
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_default_vpc" "default" {}
resource "aws_default_subnet" "central-1a" {
  availability_zone = "eu-central-1a"
}
resource "aws_default_subnet" "central-1b" {
  availability_zone = "eu-central-1b"
}
resource "aws_default_subnet" "central-1c" {
  availability_zone = "eu-central-1c"
}

resource "aws_db_instance" "default" {
  availability_zone = "eu-central-1a"

  allocated_storage = 10
  storage_type = "gp2"
  engine = "postgres"
  instance_class = "db.t2.micro"
  name = "core"
  port = 5432
  engine_version = "10"

  skip_final_snapshot = true
  final_snapshot_identifier = "snap-1"

  username = "${var.username}"
  password = "${var.password}"
}

variable "username" {}
variable "password" {}