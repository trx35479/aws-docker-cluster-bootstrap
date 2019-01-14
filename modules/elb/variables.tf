variable "ELB_NAME" {}

variable "SUBNET_IDS" {
  type = "list"
}

variable "SECURITY_GROUPS" {
  type = "list"
}

variable "INSTANCE_PORT" {}

variable "INSTANCE_PROTOCOL" {}

variable "LB_PORT" {}

variable "LB_PROTOCOL" {}
