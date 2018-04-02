provider "heroku" {
    email = "sebastrident@gmail.com"
    api_key = "${var.heroku_api_key}"
}

resource "heroku_app" "judge_re" {
    name = "judge-re"
    region = "us"

    buildpacks = [
        "heroku/gradle"
    ]
}

resource "heroku_addon" "rdb" {
    app = "${heroku_app.judge_re.name}"
    plan = "heroku-postgresql:hobby-dev"
}

resource "heroku_addon" "logging" {
    app = "${heroku_app.judge_re.name}"
    plan = "coralogix:free"
}
