terraform {
  required_version = ">= 0.13.0"

  required_providers {
    aws = "= 3.0.0"
  }

  backend "s3" {
    bucket = "tfstatebucket-aberg"
    key    = "test-tf-project/simpleec2/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = var.region
}