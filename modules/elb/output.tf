output "load_balancer" {
  value = "${aws_elb.docker-elb.id}"
}
