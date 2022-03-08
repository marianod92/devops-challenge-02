data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

#Remote States
data "terraform_remote_state" "remote_dns" {
  backend = "s3"
  config = {
    bucket = "playground-global-use1-tfstates-s3"
    key    = "global/route53/terraform.tfstate"
    region = "us-east-1"
  }
}