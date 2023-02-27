terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  # Adding Backend as S3 for Remote State Storage
  backend "s3" {
    bucket               = "demo-2222023"
    workspace_key_prefix = "workspaces"
    key                  = "demo01-terraform-state"
    region               = "us-west-2"
    # for state locking
    dynamodb_table = "demo01"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-west-2"

  default_tags { #default tags are used to automatically assign tags to resources with the same value
    tags = {
      environment = var.env
      project     = var.project
    }
  }
}