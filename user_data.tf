# use instead user_data to be pass on to instances
# cloud_init will execute the template

data "template_file" "master" {
  template = "${file("script/master_script.sh")}"
}

data "template_file" "master_standby" {
  template = "${file("script/master_standby_script.sh")}"

  vars {
    master_ip = "${aws_instance.docker-master.private_ip}"
  }
}

data "template_file" "worker" {
  template = "${file("script/worker_script.sh")}"

  vars {
    master_ip = "${aws_instance.docker-master.private_ip}"
  }
}
