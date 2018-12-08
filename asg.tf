# create a auto-scaling for workers 
resource "aws_placement_group" "docker" {
  name     = " docker"
  strategy = "cluster"
}

resource "aws_launch_configuration" "docker-instance-config" {}

resource "aws_autoscaling_group" "docker" {
  name                      = "docker-auto-scaling"
  max_size                  = 10
  min_size                  = 3
  health_check_grace_period = 300
  health_check_type         = "elb"
  desired_capacity          = 3
  force_delete              = true
  placement_group           = "${aws_placement_group.docker.id}"
  launch_configuration      = "${aws_launch_configuration.docker-instance-config.name}"
  vpc_zone_identifier       = "${var.SUBNET}"
}

# attached to an ELB
resource "aws_autoscaling_attachement" "docker-asg-lb-attach" {
  aws_autoscaling_group_name = "${aws_autoscaling_group.docker.id}"
  elb                        = "${aws_elb.docker-elb.id}"
}
