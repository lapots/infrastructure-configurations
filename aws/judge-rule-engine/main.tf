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

resource "aws_elastic_beanstalk_application" "judge" {
  name = "judge-rule-engine"
  description = "Judge rule engine"
}

locals {
  subnets = [
    "${aws_default_subnet.central-1a.id}",
    "${aws_default_subnet.central-1b.id}",
    "${aws_default_subnet.central-1c.id}"
  ]
}

resource "aws_elastic_beanstalk_environment" "judge_env" {
  name = "judge-rule-engine-env"
  application = "judge-rule-engine"
  cname_prefix = "judge"

  solution_stack_name = "64bit Amazon Linux 2017.09 v2.6.8 running Java 8"

  setting {
    name = "VPCId"
    namespace = "aws:ec2:vpc"
    value = "${aws_default_vpc.default.id}"
  }

  setting {
    name = "Subnets"
    namespace = "aws:ec2:vpc"
    value = "${join(",", local.subnets)}"
  }
}
