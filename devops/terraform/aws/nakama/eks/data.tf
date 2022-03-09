data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

#Remote States
data "terraform_remote_state" "remote_vpc" {
  backend = "s3"
  config = {
    bucket = "playground-devops-challenges-use1-tfstates-s3"
    key    = "devops-challenges-02/terraform/aws/nakama/vpc"
    region = "us-east-1"
  }
}