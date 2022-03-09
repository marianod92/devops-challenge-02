region             = "us-east-1"
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
namespace          = "playground"
stage              = "devops"
environment        = "challange"
name               = "nakama"
label_order        = ["namespace", "stage", "name", "attributes"]
cidr_block         = "10.0.0.0/16"