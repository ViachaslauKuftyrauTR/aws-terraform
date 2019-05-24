resource "aws_launch_configuration" "nginx" {
  image_id = "${var.ami}"
  instance_type = "t2.micro"
  security_groups = ["${var.security_group_id}"]
  user_data = <<EOF
#!/bin/bash
echo "start" > /home/ubuntu/start
sudo apt-get update -y
sudo apt-get install -y nginx
sudo su -c 'echo $HOSTNAME > /var/www/html/index.html'
sudo su -c 'echo autoscaled `date` >> /var/www/html/index.html'
  EOF
  lifecycle {
    create_before_destroy = true
  }


}

resource "aws_autoscaling_group" "nodes" {
  launch_configuration  = "${aws_launch_configuration.nginx.id}"
  availability_zones    = ["${var.az}"]
  min_size              = "${var.min_instance_count}"
  max_size              = "${var.max_instance_count}"
  load_balancers        = ["${var.elb_name}"]
  health_check_type     = "ELB"
  vpc_zone_identifier   = ["${var.subnet_id}"]
  tags {
    key                 = "name"
    value               = "Node"
    propagate_at_launch = true
  }
}