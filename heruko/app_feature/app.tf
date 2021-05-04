provider "heroku" {}
variable "name" {
  type = string
}

resource "heroku_app" "default" {
  name   = var.name
  region = "us"
}

resource "heroku_build" "foobar" {
  app        = heroku_app.default.id
  buildpacks = ["https://github.com/mars/create-react-app-buildpack"]

  source = {
    # This app uses a community buildpack, set it in `buildpacks` above.
    url     = "https://github.com/mars/cra-example-app/archive/v2.1.1.tar.gz"
    version = "v2.1.1"

    # Or Path to local files
    # path = "src/example-app"
  }
}