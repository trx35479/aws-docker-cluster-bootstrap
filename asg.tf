# create a auto-scaling for workers 
resource "aws_launch_configuration" "docker-instance-config" {
  image_id        = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type   = "t2.micro"
  key_name        = "${aws_key_pair.mykeypair.key_name}"
  security_groups = ["${var.SECURITY_GROUPS}"]

  user_data = "${data.template_file.worker.rendered}"
}

# define the auto-scaling-group for docker workers
resource "aws_autoscaling_group" "docker-asg" {
  name                      = "docker-auto-scaling"
  max_size                  = 10
  min_size                  = 3
  health_check_grace_period = 300
  health_check_type         = "ELB"
  load_balancers            = ["${aws_elb.docker-elb.id}"]

  #  desired_capacity = 3 # omit this base on the terraform documents if we use a auto_scaling_policy
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.docker-instance-config.name}"
  vpc_zone_identifier  = ["${var.SUBNET_ID}"]                                      # could be multiple subnet in different availability zone

  tag {
    key                 = "Name"
    value               = "docker-asg-instances"
    propagate_at_launch = true
  }

  tag {
    key                 = "Owner"
    value               = "Rowel Uchi"
    propagate_at_launch = true
  }

  tag {
    key                 = "Schedule"
    value               = "10x5"
    propagate_at_launch = true
  }
}

# define the scaling out policy
resource "aws_autoscaling_policy" "docker-asg-scaleout" {
  name                   = "docker-asg-scaleout"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.docker-asg.name}"
}

# define the scaling in policy
resource "aws_autoscaling_policy" "docker-asg-scalein" {
  name                   = "docker-asg-scalein"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.docker-asg.name}"
}

# define the cloud watch for scaleout policy
resource "aws_cloudwatch_metric_alarm" "docker-high-alarm" {
  alarm_name          = "docker-high-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.docker-asg.name}"
  }

  alarm_description = "This is monitors the EC2 instance high CPU alarm"
  alarm_actions     = ["${aws_autoscaling_policy.docker-asg-scaleout.arn}"]
}

# define the cloud watch for scalein policy
resource "aws_cloudwatch_metric_alarm" "docker-low-alarm" {
  alarm_name          = "docker-low-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "20"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.docker-asg.name}"
  }

  alarm_description = "This is monitors the EC2 instance low CPU alarm"
  alarm_actions     = ["${aws_autoscaling_policy.docker-asg-scalein.arn}"]
}
