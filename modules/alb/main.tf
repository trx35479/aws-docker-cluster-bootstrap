# Option to use ALB instead of ELB
resource "aws_alb" "alb" {
  name               = "${var.ALB_NAME}-alb"
  internal           = "${var.INTERNAL}"
  load_balancer_type = "application"
  security_groups    = ["${var.SECURITY_GROUPS}"]
  subnets            = ["${var.SUBNET_IDS}"]

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "alb-target" {
  name        = "${var.ALB_NAME}-alb-target"
  port        = 3000
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = "${var.VPC_ID}"

  health_check {
    protocol            = "HTTP"
    path                = "/login"
    port                = 3000
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
}

resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${var.CERTw}"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.alb-target.arn}"
  }
}
