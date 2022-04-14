terraform {
  required_providers {
    bigip = {
      source = "F5Networks/bigip"
      version = "1.13.0"
    }
  }
    cloud {
    organization = "sebbycorp"

    workspaces {
      name = "f5"
    }
  }
}
