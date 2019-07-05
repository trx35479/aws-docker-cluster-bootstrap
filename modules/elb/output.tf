output "load_balancer" {
  value = "${aws_elb.docker-elb.id}"
}

output "private_dns" {
  value = "${aws_elb.docker-elb.dns_name}"
}
