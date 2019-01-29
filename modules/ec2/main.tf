# Define the master and leader of the docker swarm
# Define a number of manager and join it to swarm

resource "aws_instance" "master-instance" {
  ami                    = "${var.IMAGE_ID}"
  count                  = "${var.MASTER[0] == "true" ? var.MASTER[1] : var.MASTER[1]}"
  instance_type          = "${var.FLAVOR}"
  subnet_id              = "${element(var.AVAILABILITY_ZONE, count.index)}"
  vpc_security_group_ids = ["${var.SECURITY_GROUPS}"]
  key_name               = "${var.AWS_KEYPAIR}"
  user_data              = "${var.USER_DATA}"

  tags {
    Name     = "${var.CLUSTER_NAME}-Instance-${count.index +1}"
    Owner    = "Rowel Uchi"
    Schedule = "10x5"
  }
}
