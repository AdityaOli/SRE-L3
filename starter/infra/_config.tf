terraform {
  backend "s3" {
    bucket = "udacity-tf-adityaoli-lesson3" # Update here with your S3 bucket
    key    = "terraform/terraform.tfstate"
    region = "us-east-2"
    encrypt = true
    profile = "admin"
  }
}

provider "aws" {
  region = "us-east-2"
  profile = "admin"
  default_tags {
    tags = local.tags
  }
}