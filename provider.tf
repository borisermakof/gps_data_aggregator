terraform {
  required_version = ">= 1.3.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.48"
    }
  }

  backend "s3" {
    bucket = "terraform-main-hive-test-task"
    key    = "terraform-main-hive-test-task.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = var.env
    }
  }
}

