# This is the aws version of instantiating an docker swarm cluster

provider "aws" {
  region = "${var.AWS_REGION}"
}

resource "aws_key_pair" "mykeypair" {
  key_name   = "${var.CLUSTER_NAME}-mykeypair"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

module "compute" {
  source = "modules/compute"

  CLUSTER_NAME              = "${var.CLUSTER_NAME}"
  AWS_KEYPAIR               = "${aws_key_pair.mykeypair.key_name}"
  IMAGE_ID                  = "${lookup(var.IMAGE_ID, var.LINUX_DISTRO)}"
  MANAGER_FLAVOR            = "${var.MANAGER_FLAVOR}"
  MANAGER_AVAILABILITY_ZONE = "${lookup(var.VPC_SUBNET, var.AZ2a)}"
  STANDBY_AVAILABILITY_ZONE = "${lookup(var.VPC_SUBNET, var.AZ2b)}"
  SECURITY_GROUPS           = "${var.SECURITY_GROUPS}"
  MANAGER_COUNT             = "${var.MANAGER_COUNT}"
  STANDBY_COUNT             = "${var.STANDBY_COUNT}"
}

module "asg" {
  source = "modules/asg"

  CLUSTER_NAME       = "${var.CLUSTER_NAME}"
  AWS_KEYPAIR        = "${aws_key_pair.mykeypair.key_name}"
  IMAGE_ID           = "${lookup(var.IMAGE_ID, var.LINUX_DISTRO)}"
  WORKER_FLAVOR      = "${var.WORKER_FLAVOR}"
  SUBNET_IDS         = "${var.SUBNET_IDS}"
  SECURITY_GROUPS    = "${var.SECURITY_GROUPS}"
  MIN_NUMBER_OF_INST = "${var.MIN_NUMBER_OF_INST}"
  MAX_NUMBER_OF_INST = "${var.MAX_NUMBER_OF_INST}"
  LOAD_BALANCERS     = "${module.elb.load_balancer}"
}

module "elb" {
  source = "modules/elb"

  ELB_NAME          = "${var.CLUSTER_NAME}"
  SUBNET_IDS        = "${var.SUBNET_IDS}"
  SECURITY_GROUPS   = "${var.SECURITY_GROUPS}"
  INSTANCE_PORT     = "${var.INSTANCE_PORT}"
  INSTANCE_PROTOCOL = "${var.INSTANCE_PROTOCOL}"
  LB_PORT           = "${var.LB_PORT}"
  LB_PROTOCOL       = "${var.LB_PROTOCOL}"
}
