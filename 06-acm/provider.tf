terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 5.95.0"
    }
  }

  backend "s3" {
    bucket = "devopswithmsvs"
    key    = "expense-eks-acm"
    region = "us-east-1"
    use_lockfile = true
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-1"
}