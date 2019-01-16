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

module "ec2" {
  source = "modules/ec2"

  CLUSTER_NAME              = "${var.CLUSTER_NAME}"
  AWS_KEYPAIR               = "${aws_key_pair.mykeypair.key_name}"
  IMAGE_ID                  = "${lookup(var.IMAGE_ID, var.LINUX_DISTRO)}"
  MANAGER_FLAVOR            = "t2.micro"
  MANAGER_AVAILABILITY_ZONE = "${module.vpc.main-public-1}"
  STANDBY_AVAILABILITY_ZONE = "${module.vpc.main-public-2}"
  SECURITY_GROUPS           = ["${module.vpc.external-secg}", "${module.vpc.internal-secg}"]
  STANDBY_COUNT             = 2
  MANAGER_USER_DATA         = "${data.template_file.master.rendered}"
  STANDBY_USER_DATA         = "${data.template_file.master_standby.rendered}"
}

module "asg" {
  source = "modules/asg"

  CLUSTER_NAME     = "${var.CLUSTER_NAME}"
  AWS_KEYPAIR      = "${aws_key_pair.mykeypair.key_name}"
  IMAGE_ID         = "${lookup(var.IMAGE_ID, var.LINUX_DISTRO)}"
  WORKER_FLAVOR    = "t2.micro"
  SUBNET_IDS       = ["${module.vpc.main-public-1}", "${module.vpc.main-public-2}", "${module.vpc.main-public-3}"]
  SECURITY_GROUPS  = ["${module.vpc.external-secg}", "${module.vpc.internal-secg}"]
  MIN_NUMBER_INST  = 2
  MAX_NUMBER_INST  = 10
  ALB_ARN          = "${module.alb.alb-target}"
  WORKER_USER_DATA = "${data.template_file.worker.rendered}"
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
