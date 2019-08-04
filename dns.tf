# hook the alb to dns cname
data "aws_route53_zone" "zone" {
  name         = "thecloudnative.io."
  private_zone = false
}

data "aws_acm_certificate" "cert" {
  domain   = "*.thecloudnative.io"
  statuses = ["ISSUED"]
}

resource "aws_route53_record" "record" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "grafana.${data.aws_route53_zone.zone.name}"
  type    = "CNAME"
  ttl     = "5"
  records        = ["${module.alb.alb-dns}"]
}

resource "aws_lb_listener_certificate" "example" {
  listener_arn    = "${module.alb.listener_arn}"
  certificate_arn = "${data.aws_acm_certificate.cert.arn}"
}
