# elb for the worker asg
# ELB config
# define the elastic loab balancing
resource "aws_elb" "docker-elb" {
  name            = "${var.ELB_NAME}-elb"
  subnets         = ["${var.SUBNET_IDS}"]      #either subnets id or availability zones
  security_groups = ["${var.SECURITY_GROUPS}"]
  internal        = true

  # define the listener port / could be mutiple port depends on available application running
  listener {
    instance_port     = "${var.INSTANCE_PORT}"
    instance_protocol = "${var.INSTANCE_PROTOCOL}"
    lb_port           = "${var.LB_PORT}"
    lb_protocol       = "${var.LB_PROTOCOL}"
  }

  # define the health check
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "${var.LB_PROTOCOL}:${var.LB_PORT}/login"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name     = "${var.ELB_NAME}-elb"
    Owner    = "Rowel Uchi"
    Schedule = "10x5"
  }
}
