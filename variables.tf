variable "AWS_REGION" {
  default = "ap-southeast-2"
}

variable "CLUSTER_NAME" {
  default = "dswarm"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "~/.ssh/id_rsa.pub"
}

variable "WORKER_FLAVOR" {
  default = "t2.micro"
}

variable "MANAGER_FLAVOR" {
  default = "t2.micro"
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

variable "SECURITY_GROUPS" {
  type    = "list"
  default = ["sg-026a171bf561f41b1", "sg-0547e253e11bdd32c", "sg-0b9e906fadf75fa24"]
}

variable "SUBNET_IDS" {
  type    = "list"
  default = ["subnet-00e4e51e48c55b4bc", "subnet-0cdecde48cde871f5", "subnet-0f5447f85d325c988"]
}

variable "VPC_SUBNET" {
  type = "map"

  default {
    ap-southeast-2c = "subnet-00e4e51e48c55b4bc"
    ap-southeast-2b = "subnet-0cdecde48cde871f5"
    ap-southeast-2a = "subnet-0f5447f85d325c988"
  }
}

variable "MIN_NUMBER_OF_INST" {
  default = 2
}

variable "MAX_NUMBER_OF_INST" {
  default = 10
}

variable "AZ2a" {
  default = "ap-southeast-2a"
}

variable "AZ2b" {
  default = "ap-southeast-2b"
}

variable "AZ2c" {
  default = "ap-southeast-2c"
}

variable "INSTANCE_PORT" {
  default = 3000
}

variable "INSTANCE_PROTOCOL" {
  default = "http"
}

variable "LB_PORT" {
  default = 3000
}

variable "LB_PROTOCOL" {
  default = "http"
}

variable "MANAGER_COUNT" {
  default = 1
}

variable "STANDBY_COUNT" {
  default = 2
}
