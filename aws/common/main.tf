terraform {
  backend "s3" {
    bucket = "s3-terraform-state-backend"
    region = "eu-central-1"
    key = "common/terraform.tfstate"
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
    Environment = "Dev"
  }
}

resource "aws_subnet" "intranet" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-central-1a"
  tags {
    Name = "Intranet"
    Environemnt = "Dev"
  }
}

# should contain configuration for common components (rds, sqs etc.)
resource "aws_db_subnet_group" "db_subnet" {
  name = "intranet"
  subnet_ids = ["${aws_subnet.intranet.id}"]
}

resource "aws_db_instance" "core" {
  name = "gj-core-db"
  engine = "postgres"

  allocated_storage = 10
  storage_type = "gp2"
  instance_class = "db.t2.micro"

  db_subnet_group_name = "${aws_db_subnet_group.db_subnet.name}"
}
