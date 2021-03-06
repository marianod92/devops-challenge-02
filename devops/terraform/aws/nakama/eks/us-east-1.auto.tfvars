region                            = "us-east-1"
availability_zones                = ["us-east-1a", "us-east-1b", "us-east-1c"]
namespace                         = "playground"
stage                             = "devops"
environment                       = "challange"
name                              = "nakama"
label_order                       = ["namespace", "stage", "name", "attributes"]
kubernetes_version                = "1.21"
oidc_provider_enabled             = true
enabled_cluster_log_types         = ["audit"]
cluster_log_retention_period      = 7
instance_types                    = ["t3.medium"]
desired_size                      = 2
max_size                          = 3
min_size                          = 2
kubernetes_labels                 = {}
cluster_encryption_config_enabled = true
addons = [
  {
    addon_name               = "vpc-cni"
    addon_version            = null
    resolve_conflicts        = "NONE"
    service_account_role_arn = null
  }
]
deploy_apps = false