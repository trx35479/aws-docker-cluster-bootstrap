variable "CLUSTER_NAME" {}

variable "AWS_KEYPAIR" {}

variable "WORKER_FLAVOR" {}

variable "IMAGE_ID" {}

variable "SUBNET_IDS" {
  type = "list"
}

variable "SECURITY_GROUPS" {
  type = "list"
}

variable "WORKER_USER_DATA" {}

variable "MIN_NUMBER_OF_INST" {}

variable "MAX_NUMBER_OF_INST" {}

#variable "LOAD_BALANCERS" {}

variable "ALB_ARN" {}
