variable "CLUSTER_NAME" {}

variable "IMAGE_ID" {}

variable "MANAGER_FLAVOR" {}

variable "MANAGER_COUNT" {}

variable "STANDBY_COUNT" {}

variable "SECURITY_GROUPS" {
  type = "list"
}

variable "AWS_KEYPAIR" {}

variable "MANAGER_AVAILABILITY_ZONE" {}
variable "STANDBY_AVAILABILITY_ZONE" {}
