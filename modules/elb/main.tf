resource "aws_elb" "kuftyrau_elb" {
  name               = "kuftyrau-elb"

  
  subnets         = ["${var.subnet_id}"]
  security_groups = ["${var.security_group_id}",]
  instances = ["${var.instance_id}"]

  access_logs {
    bucket    = "${var.bucket}"
    interval  = "5"
    enabled   = "true"
  }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
  tags = {
    Name = "kuftyrau_elb"
  }
}