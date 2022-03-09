
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.38, < 4.0.0"
    }
    template = {
      source  = "hashicorp/template"
      version = ">= 2.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 1.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 1.13"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 2.2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.4.1"
    }
    utils = {
      source  = "cloudposse/utils"
      version = ">= 0.17.7"
    }
  }
}