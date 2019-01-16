# This is the aws version of instantiating n docker swarm cluster

provider "aws" {
  region = "${var.AWS_REGION}"
}

resource "aws_key_pair" "mykeypair" {
  key_name   = "${var.CLUSTER_NAME}-mykeypair"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

module "vpc" {
  source = "modules/vpc"

  AWS_REGION       = "${var.AWS_REGION}"
  CLUSTER_NAME     = "${var.CLUSTER_NAME}"
  VPC_CIDR_BLOCK   = "${var.VPC_CIDR_BLOCK}"
  SUBNET_PUBLIC-1  = "${var.SUBNET_PUBLIC-1}"
  SUBNET_PUBLIC-2  = "${var.SUBNET_PUBLIC-2}"
  SUBNET_PUBLIC-3  = "${var.SUBNET_PUBLIC-3}"
  SUBNET_PRIVATE-1 = "${var.SUBNET_PRIVATE-1}"
  SUBNET_PRIVATE-2 = "${var.SUBNET_PRIVATE-2}"
  SUBNET_PRIVATE-3 = "${var.SUBNET_PRIVATE-3}"
}

module "compute" {
  source = "modules/compute"

  CLUSTER_NAME              = "${var.CLUSTER_NAME}"
  AWS_KEYPAIR               = "${aws_key_pair.mykeypair.key_name}"
  IMAGE_ID                  = "${lookup(var.IMAGE_ID, var.LINUX_DISTRO)}"
  MANAGER_FLAVOR            = "${var.MANAGER_FLAVOR}"
  MANAGER_AVAILABILITY_ZONE = "${module.vpc.main-public-1}"
  STANDBY_AVAILABILITY_ZONE = "${module.vpc.main-public-2}"
  SECURITY_GROUPS           = ["${module.vpc.external-secg}", "${module.vpc.internal-secg}"]
  STANDBY_COUNT             = "${var.STANDBY_COUNT}"
  MANAGER_USER_DATA         = "${data.template_file.master.rendered}"
  STANDBY_USER_DATA         = "${data.template_file.master_standby.rendered}"
}

module "asg" {
  source = "modules/asg"

  CLUSTER_NAME       = "${var.CLUSTER_NAME}"
  AWS_KEYPAIR        = "${aws_key_pair.mykeypair.key_name}"
  IMAGE_ID           = "${lookup(var.IMAGE_ID, var.LINUX_DISTRO)}"
  WORKER_FLAVOR      = "${var.WORKER_FLAVOR}"
  SUBNET_IDS         = ["${module.vpc.main-public-1}", "${module.vpc.main-public-2}", "${module.vpc.main-public-3}"]
  SECURITY_GROUPS    = ["${module.vpc.external-secg}", "${module.vpc.internal-secg}"]
  MIN_NUMBER_OF_INST = "${var.MIN_NUMBER_OF_INST}"
  MAX_NUMBER_OF_INST = "${var.MAX_NUMBER_OF_INST}"
  ALB_ARN            = "${module.alb.alb-target}"
  WORKER_USER_DATA   = "${data.template_file.worker.rendered}"
}

module "alb" {
  source = "modules/alb"

  ALB_NAME        = "${var.CLUSTER_NAME}"
  INTERNAL        = "false"
  SECURITY_GROUPS = ["${module.vpc.external-secg}", "${module.vpc.internal-secg}"]
  SUBNET_IDS      = ["${module.vpc.main-public-1}", "${module.vpc.main-public-2}", "${module.vpc.main-public-3}"]
  VPC_ID          = "${module.vpc.vpc_id}"
}

output "alb-target" {
  value = "${module.alb.alb-target}"
}
