output "alb-target" {
  value = "${aws_lb_target_group.alb-target.arn}"
}

output "alb-dns" {
  value = "${aws_alb.alb.dns_name}"
}

output "listener_arn" {
  value = "${aws_lb_listener.alb-listener.arn}"
}