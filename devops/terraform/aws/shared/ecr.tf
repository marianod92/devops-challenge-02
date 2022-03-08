module "ecr" {
  source                   = "cloudposse/ecr/aws"
  version                  = "v0.32.3"
  name                     = "ecr"
  encryption_configuration = var.encryption_configuration
  image_names              = ["nakama"]
  context                  = module.this.context
}