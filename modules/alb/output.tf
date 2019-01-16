output "alb-target" {
  value = "${aws_lb_target_group.alb-target.arn}"
}

output "alb-dns" {
  value = "${aws_alb.alb.dns_name}"
}
