variable "AWS_REGION" {}
variable "CLUSTER_NAME" {}
variable "VPC_CIDR_BLOCK" {}

variable "PUBLIC_SUBNET" {
  type = "list"
}

variable "PRIVATE_SUBNET" {
  type = "list"
}

#variable "SUBNET_PUBLIC-2" {}
#variable "SUBNET_PUBLIC-3" {}
#
#variable "SUBNET_PRIVATE-1" {}
#variable "SUBNET_PRIVATE-2" {}
#variable "SUBNET_PRIVATE-3" {}

