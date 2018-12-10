# define the elastic loab balancing
resource "aws_elb" "docker-elb" {
  name            = "docker-elb"
  subnets         = ["${var.SUBNET_ID}"]       #either subnets id or availability zones
  security_groups = ["${var.SECURITY_GROUPS}"]
  internal        = true

  # define the listener port / could be mutiple port depends on available application running
  listener {
    instance_port     = 3000
    instance_protocol = "http"
    lb_port           = 3000
    lb_protocol       = "http"
  }

  # define the health check 
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:3000/login"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name     = "docker-elb"
    Owner    = "Rowel Uchi"
    Schedule = "10x5"
  }
}
