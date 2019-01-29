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

  AWS_REGION     = "${var.AWS_REGION}"
  CLUSTER_NAME   = "${var.CLUSTER_NAME}"
  VPC_CIDR_BLOCK = "10.212.0.0/16"
  PUBLIC_SUBNET  = ["10.212.10.0/24", "10.212.30.0/24", "10.212.50.0/24"]
  PRIVATE_SUBNET = ["10.212.20.0/24", "10.212.40.0/24", "10.212.60.0/24"]
}

module "master" {
  source = "modules/ec2"

  CLUSTER_NAME      = "${var.CLUSTER_NAME}"
  AWS_KEYPAIR       = "${aws_key_pair.mykeypair.key_name}"
  IMAGE_ID          = "${lookup(var.IMAGE_ID, var.LINUX_DISTRO)}"
  FLAVOR            = "t2.micro"
  AVAILABILITY_ZONE = "${module.vpc.public_subnets}"
  SECURITY_GROUPS   = "${module.vpc.security_groups}"
  MASTER            = ["true", 1]
  USER_DATA         = "${data.template_file.master.rendered}"
}

module "standby" {
  source = "modules/ec2"

  CLUSTER_NAME      = "${var.CLUSTER_NAME}"
  AWS_KEYPAIR       = "${aws_key_pair.mykeypair.key_name}"
  IMAGE_ID          = "${lookup(var.IMAGE_ID, var.LINUX_DISTRO)}"
  FLAVOR            = "t2.micro"
  AVAILABILITY_ZONE = "${module.vpc.public_subnets}"
  SECURITY_GROUPS   = "${module.vpc.security_groups}"
  MASTER            = ["false", 2]
  USER_DATA         = "${data.template_file.master_standby.rendered}"
}

module "asg" {
  source = "modules/asg"

  CLUSTER_NAME     = "${var.CLUSTER_NAME}"
  AWS_KEYPAIR      = "${aws_key_pair.mykeypair.key_name}"
  IMAGE_ID         = "${lookup(var.IMAGE_ID, var.LINUX_DISTRO)}"
  WORKER_FLAVOR    = "t2.micro"
  SUBNET_IDS       = "${module.vpc.public_subnets}"
  SECURITY_GROUPS  = "${module.vpc.security_groups}"
  MIN_NUMBER_INST  = 2
  MAX_NUMBER_INST  = 5
  ALB_ARN          = "${module.alb.alb-target}"
  WORKER_USER_DATA = "${data.template_file.worker.rendered}"
}

module "alb" {
  source = "modules/alb"

  ALB_NAME        = "${var.CLUSTER_NAME}"
  INTERNAL        = "false"
  SECURITY_GROUPS = "${module.vpc.security_groups}"
  SUBNET_IDS      = "${module.vpc.public_subnets}"
  VPC_ID          = "${module.vpc.vpc_id}"
}

output "alb_target" {
  value = "${module.alb.alb-target}"
}

output "master_ip" {
  value = "${module.master.master_ip}"
}
