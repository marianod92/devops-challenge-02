terraform {
  required_version = "> 1.0.0"

  backend "s3" {
    region  = "us-east-1"
    bucket  = "playground-devops-challenges-use1-tfstates-s3"
    key     = "devops-challenges-02/terraform/aws/nakama/vpc-anton"
    encrypt = "true"
  }
}