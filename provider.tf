terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # backend "s3" {
  #       bucket = "ninja-terraform-s3-bucket"
  #       key    = "ninja/terraform/remote/s3/terraform.tfstate"
  #       region     = "ap-south-1"
  #      dynamodb_table  = "dynamodb-state-locking"
  #   }
}

provider "aws" {
  region = "ap-south-1"
}