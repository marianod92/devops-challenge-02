enabled            = false
region             = "us-east-1"
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
namespace          = "playground"
stage              = "devops"
environment        = "challange"
name               = "nakama"
label_order        = ["namespace", "stage", "name", "attributes"]
encryption_configuration = {
  encryption_type = "AES256"
  kms_key         = null
}