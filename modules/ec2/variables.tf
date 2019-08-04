variable "CLUSTER_NAME" {}

variable "IMAGE_ID" {}

variable "FLAVOR" {}

variable "MASTER" {
  type = "list"
}

variable "SECURITY_GROUPS" {
  type = "list"
}

variable "AWS_KEYPAIR" {}

variable "AVAILABILITY_ZONE" {
  type = "list"
}

variable "USER_DATA" {}
