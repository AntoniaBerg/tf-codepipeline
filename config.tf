terraform {
  required_version = ">= 0.13.0"

  required_providers {
    aws = "= 3.0.0"
  }

  // set up your own backend here
  backend "s3" {
    bucket = "tfstatebucket-aberg"
    key    = "test-tf-project/tf-codepipeline/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = var.region
}