# Define the master and leader of the docker swarm
resource "aws_instance" "docker-master" {
  ami                    = "${lookup(var.AMIS, var.AWS_REGION)}"
  count                  = "1"
  instance_type          = "t2.micro"
  subnet_id              = "${var.SUBNET_ID}"
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
  subnet_id              = "${var.SUBNET_ID}"
  vpc_security_group_ids = ["${var.SECURITY_GROUPS}"]
  key_name               = "${aws_key_pair.mykeypair.key_name}"

  connection {
    host        = "${self.private_ip}"
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${file(var.PATH_TO_PRIVATE_KEY)}"
  }

  provisioner "file" {
    source      = "${var.PATH_TO_PRIVATE_KEY}"
    destination = "/home/ubuntu/mykey.pem"
  }

  user_data = "${data.template_file.master_standby.rendered}"

  tags {
    Name     = "Test Instance Using Tf"
    Owner    = "Rowel Uchi"
    Schedule = "10x5"
  }
}
