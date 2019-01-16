# use instead user_data to be pass on to instances
# cloud_init will execute the template

data "template_file" "master" {
  template = "${file("templates/master_script.tpl")}"
}

data "template_file" "master_standby" {
  template = "${file("templates/master_standby_script.tpl")}"

  vars {
    private_key = "${file(var.PATH_TO_PRIVATE_KEY)}"
    master_ip   = "${module.ec2.master_ip}"
  }
}

data "template_file" "worker" {
  template = "${file("templates/worker_script.tpl")}"

  vars {
    private_key = "${file(var.PATH_TO_PRIVATE_KEY)}"
    master_ip   = "${module.ec2.master_ip}"
  }
}
