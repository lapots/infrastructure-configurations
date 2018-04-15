provider "aws" {
  region = "eu-central-1"
}

# mvn repo
resource "aws_s3_bucket" "mvn_repo" {
  bucket = "repo.mvn.dev"
  acl = "private"

  tags {
    Name = "MVN artifactory bucket"
    Environment = "Dev"
  }
}

# IAM user
resource "aws_iam_user" "mvn_user" {
  name = "artifactory_user"
}

resource "aws_iam_access_key" "mvn_user" {
  user = "${aws_iam_user.mvn_user.name}"
}

resource "aws_iam_user_policy" "mvn_user_rw" {
  name = "artifactory_user_policy"
  user = "${aws_iam_user.mvn_user.name}"
  policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.mvn_repo.bucket}",
        "arn:aws:s3:::${aws_s3_bucket.mvn_repo.bucket}/*"
      ]
    }
  ]
}
EOF
}
