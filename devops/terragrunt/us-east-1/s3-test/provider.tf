# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  required_version = ">= 1.0.0"
}

provider "aws" {
  region              = "us-east-1"
  profile             = var.profile
  allowed_account_ids = var.allowed_accounts_ids
  # assume_role {
  #   role_arn = var.provider_env_roles["us-east-1"]
  # }
  default_tags {
    tags = {
      "Created by" : "Terraform",
    }
  }
}

variable "allowed_accounts_ids" {
  type = list(string)
}

variable "region" {
  type = string
}

variable "namespace" {
  type = string
}

variable "environment" {
  type = string
}

variable "profile" {
  type = string
}

variable "name" {
  type = string
}

variable "delimiter" {
  type    = string
  default = "-"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "s3_bucket_tfstate_name" {
  type = string
}