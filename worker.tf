# Define the resource of docker worker
resource "aws_instance" "docker-worker" {
  ami                    = "${lookup(var.AMIS, var.AWS_REGION)}"
  count                  = "3"
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

  tags {
    Name     = "Test Instance Using Tf"
    Owner    = "Rowel Uchi"
    Schedule = "10x5"
  }

  user_data = "${data.template_file.worker.rendered}"
}
