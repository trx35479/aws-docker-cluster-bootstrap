# Define the master and leader of the docker swarm
resource "aws_instance" "docker-master" {
  ami                    = "${lookup(var.AMIS, var.AWS_REGION)}"
  count                  = "1"
  instance_type          = "t2.micro"
  subnet_id              = "${lookup(var.VPC_SUBNET, var.AZ2a)}"
  vpc_security_group_ids = ["${var.SECURITY_GROUPS}"]
  key_name               = "${aws_key_pair.mykeypair.key_name}"

  user_data = "${data.template_file.master.rendered}"

  tags {
    Name     = "Test Instance Using Tf"
    Owner    = "Rowel Uchi"
    Schedule = "10x5"
  }
}

# Define a number of manager and join it to swarm
resource "aws_instance" "docker-master-standby" {
  ami                    = "${lookup(var.AMIS, var.AWS_REGION)}"
  count                  = "2"
  instance_type          = "t2.micro"
  subnet_id              = "${lookup(var.VPC_SUBNET, var.AZ2b)}"
  vpc_security_group_ids = ["${var.SECURITY_GROUPS}"]
  key_name               = "${aws_key_pair.mykeypair.key_name}"

  user_data = "${data.template_file.master_standby.rendered}"

  tags {
    Name     = "Test Instance Using Tf"
    Owner    = "Rowel Uchi"
    Schedule = "10x5"
  }
}
