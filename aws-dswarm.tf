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
  SUBNET_IDS         = "${var.SUBNET_IDS}"
  SECURITY_GROUPS    = "${var.SECURITY_GROUPS}"
  MIN_NUMBER_OF_INST = "${var.MIN_NUMBER_OF_INST}"
  MAX_NUMBER_OF_INST = "${var.MAX_NUMBER_OF_INST}"
  LOAD_BALANCERS     = "${module.elb.load_balancer}"
  WORKER_USER_DATA   = "${data.template_file.worker.rendered}"
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

output "internal_url" {
  value = "${module.elb.private_dns}"
}

output "public_url" {
  value = "${aws_route53_record.www-docker.name}"
}
