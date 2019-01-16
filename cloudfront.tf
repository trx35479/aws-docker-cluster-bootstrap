# CloudFront config
# hook either s3 bucket or dynamic website using aws application load balancer

locals {
  alb_origin_id = "${var.CLUSTER_NAME}-cf-alb"
}

resource "aws_cloudfront_distribution" "cf" {
  origin {
    domain_name = "${module.alb.alb-dns}"
    origin_id   = "${local.alb_origin_id}"

    custom_origin_config {
      http_port              = "3000"
      https_port             = "3000"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled         = true
  is_ipv6_enabled = false

  default_cache_behavior {
    allowed_methods  = ["GET", "DELETE", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.alb_origin_id}"

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  depends_on = ["module.alb"]
}

output "cloudfront_dns_name" {
  value = "${aws_cloudfront_distribution.cf.domain_name}"
}
