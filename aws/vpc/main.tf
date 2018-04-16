terraform {
  backend "s3" {
    bucket = "s3-terraform-state-backend"
    region = "eu-central-1"
    key = "vpc/terraform.tfstate"
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

resource "aws_subnet" "internet" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.0.0/24"
  availability_zone = "eu-central-1a"
  map_public_ip_on_launch = false
  tags {
    Name = "Internet"
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

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route_table" "internet_routetable" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet_gateway.id}"
  }
  tags {
    Environment = "Dev"
  }
}

resource "aws_route_table_association" "internet" {
  subnet_id = "${aws_subnet.internet.id}"
  route_table_id = "${aws_route_table.internet_routetable.id}"
}

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${aws_subnet.internet.id}"
}

resource "aws_route_table" "intranet_routetable" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat.id}"
  }
  tags {
    Environment = "Dev"
  }
}

resource "aws_route_table_association" "intranet" {
  subnet_id = "${aws_subnet.intranet.id}"
  route_table_id = "${aws_route_table.intranet_routetable.id}"
}