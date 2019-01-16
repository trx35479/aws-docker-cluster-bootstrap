variable "AWS_REGION" {
  default = "ap-southeast-2"
}

variable "CLUSTER_NAME" {
  default = "dswarm"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "~/.ssh/id_rsa.pub"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "~/.ssh/id_rsa"
}

variable "LINUX_DISTRO" {
  default = "Ubuntu"
}

variable "IMAGE_ID" {
  type = "map"

  default = {
    Ubuntu = "ami-0789a5fb42dcccc10"
    coreOS = "ami-03ec12353f77620c4"
  }
}
