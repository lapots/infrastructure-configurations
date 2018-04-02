variable "travisci_token" {}

provider "travisci" {
  github_owner = "lapots"
  travisci_token = "${var.travisci_token}"
}

resource "travisci_repository" "travis_resource" {
  slug = "lapots/xml-rule-parser"
}
