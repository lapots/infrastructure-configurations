terraform {
  backend "s3" {
    bucket = "s3-terraform-state-backend"
    region = "eu-central-1"
    key = "snitch-lambda-function/terraform.tfstate"
  }
}

variable "travisci_token" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}

provider "travisci" {
  github_owner = "lapots"
  travisci_token = "${var.travisci_token}"
}

resource "travisci_repository" "travis_resource" {
  slug = "lapots/snitch-lambda-function"
}

provider "aws" {
  region = "eu-central-1"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

resource "aws_s3_bucket" "game_rules" {
  bucket = "game_rules"
  acl = "private"

  tags {
    Name = "Game rules in XML or JSON"
    Environment = "Dev"
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id = "AllowExecutionFromS3Bucket"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.snitch.arn}"
  principal = "s3.amazonaws.com"
  source_arn = "${aws_s3_bucket.game_rules.arn}"
}

# TODO: investigate
resource "aws_lambda_function" "snitch" {
  filename = ""
  function_name = ""
  role = "${aws_iam_role.iam_for_lambda.arn}"
  handler = ""
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "${aws_s3_bucket.game_rules.id}"
  lambda_function {
    lambda_function_arn = "${aws_lambda_function.snitch.arn}"
    events = ["s3:ObjectCreated:*"]
    filter_prefix = "AWSLogs/"
    filter_suffix = ".log"
  }
}
