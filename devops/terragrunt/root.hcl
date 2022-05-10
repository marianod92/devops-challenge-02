terraform {
    extra_arguments "commons_vars" {
        commands = get_terraform_commands_that_need_vars()
        required_var_files = [
            find_in_parent_folders("commons.tfvars"),
            "custom.tfvars",
        ]
    }
}

generate "provider" {
    path = "provider.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<EOF
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
EOF
}

locals {
  rscfg = yamldecode(file("commons.yaml"))
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    region         = "${local.rscfg.region}"
    bucket         = "${local.rscfg.s3_bucket_tfstate_name}"
    key            = "${get_path_from_repo_root()}/terraform.tfstate"
    dynamodb_table = "${local.rscfg.s3_bucket_tfstate_name}-lock"
    encrypt        = true
    profile        = "${local.rscfg.profile}"
  }
}