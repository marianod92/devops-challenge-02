module "s3_bucket" {
  source                 = "cloudposse/s3-bucket/aws"
  version                = "v2.0.0"
  acl                    = "private"
  enabled                = true
  user_enabled           = true
  versioning_enabled     = false
  allowed_bucket_actions = ["s3:GetObject", "s3:ListBucket", "s3:GetBucketLocation"]
  namespace              = var.namespace
  environment            = var.environment
  name                   = var.name
}