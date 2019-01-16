variable "ALB_NAME" {}
variable "INTERNAL" {}

variable "SECURITY_GROUPS" {
  type = "list"
}

variable "SUBNET_IDS" {
  type = "list"
}

variable "VPC_ID" {}
