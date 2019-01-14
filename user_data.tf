# use instead user_data to be pass on to instances
# cloud_init will execute the template

data "template_file" "master" {
  template = "${file("templates/master_script.tpl")}"
}

data "template_file" "master_standby" {
  template = "${file("templates/master_standby_script.tpl")}"

  vars {
    master_ip = "${module.compute.master_ip}"
  }
}

data "template_file" "worker" {
  template = "${file("templates/worker_script.tpl")}"

  vars {
    master_ip = "${module.compute.master_ip}"
  }
}
