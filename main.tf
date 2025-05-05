terraform {
  required_version = "1.11.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket       = "bhapi-bucket"
    key          = "bhaws.tfstate" #keyはtfstateのファイル名を指定する
    region       = "ap-northeast-3"
    profile      = "terraform"
    use_lockfile = true
  }
}

provider "aws" {
  profile = var.profile
  region  = var.region
}

variable "profile" {
  type        = string
  description = "awsアクセス時のユーザー名"
}

variable "region" {
  type        = string
  description = "awsのリージョン"
}