# Attach ELB to Route53
# create a CNAME in Route53
data "aws_route53_zone" "elb" {
  name = "aws.unico.com.au."
}

resource "aws_route53_record" "www-docker" {
  zone_id = "${data.aws_route53_zone.elb.zone_id}"
  name    = "osev3.${data.aws_route53_zone.elb.name}"
  type    = "CNAME"
  ttl     = "5"
  records = ["${module.elb.private_dns}"]

  depends_on = [
    "module.compute",
    "module.asg",
    "module.elb"
  ]
}
