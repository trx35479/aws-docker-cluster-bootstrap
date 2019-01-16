# Define the master and leader of the docker swarm
resource "aws_instance" "master" {
  ami                    = "${var.IMAGE_ID}"
  instance_type          = "${var.MANAGER_FLAVOR}"
  subnet_id              = "${var.MANAGER_AVAILABILITY_ZONE}"
  vpc_security_group_ids = ["${var.SECURITY_GROUPS}"]
  key_name               = "${var.AWS_KEYPAIR}"
  user_data              = "${var.MANAGER_USER_DATA}"

  tags {
    Name     = "${var.CLUSTER_NAME}-Instance"
    Owner    = "Rowel Uchi"
    Schedule = "10x5"
  }
}

# Define a number of manager and join it to swarm
resource "aws_instance" "master-standby" {
  ami                    = "${var.IMAGE_ID}"
  count                  = "${var.STANDBY_COUNT}"
  instance_type          = "${var.MANAGER_FLAVOR}"
  subnet_id              = "${var.STANDBY_AVAILABILITY_ZONE}"
  vpc_security_group_ids = ["${var.SECURITY_GROUPS}"]
  key_name               = "${var.AWS_KEYPAIR}"
  user_data              = "${var.STANDBY_USER_DATA}"

  tags {
    Name     = "${var.CLUSTER_NAME}-Instance"
    Owner    = "Rowel Uchi"
    Schedule = "10x5"
  }
}
