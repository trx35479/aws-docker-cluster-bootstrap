variable "CLUSTER_NAME" {}

variable "IMAGE_ID" {}

variable "MANAGER_FLAVOR" {}

variable "ENABLED" {}

variable "SECURITY_GROUPS" {
  type = "list"
}

variable "AWS_KEYPAIR" {}

variable "MANAGER_AVAILABILITY_ZONE" {}

variable "STANDBY_AVAILABILITY_ZONE" {}

variable "MANAGER_USER_DATA" {}

variable "STANDBY_USER_DATA" {}
