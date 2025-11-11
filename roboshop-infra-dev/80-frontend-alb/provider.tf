terraform {
  backend "s3" {
    bucket = "bpotla-remotestate-backend-terraform-state"
    key    = "roboshop-dev-alb"
    region = "us-east-1"
  }


  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.16.0"
    }
  }
}


provider "aws" {
  # Configuration options
  region = "us-east-1"
}