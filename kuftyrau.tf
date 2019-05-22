provider "aws" {
  region  = "${var.region}"
  profile = "default"
}

data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket" "kuftyrau_bucket" {
  bucket = "s3-kuftyrau"
  acl    = "private"
  region = "${var.region}"
    policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::s3-kuftyrau/AWSLogs/*",
      "Principal": {
        "AWS": [
          "${data.aws_elb_service_account.main.arn}"
        ]
      }
    }
  ]
}
POLICY
}


resource "aws_vpc" "main" {
  cidr_block         = "${var.vpc_cidr}"
  enable_dns_support = true
  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "default" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "172.31.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "nodes" {
  name        = "nodes"
  description = "Used for nodes of LB"
  vpc_id      = "${aws_vpc.main.id}"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress{
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "lb" {
  name        = "lb-nodes"
  description = "Used  LB"
  vpc_id      = "${aws_vpc.main.id}"

  ingress{
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "kuftyrau_instance" {
  count         = "${var.instance_count}"
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"
  key_name      = "${lookup(var.keyname, var.region)}"
  # availability_zone      = "${var.region == "us-east-1" ? element(var.azs_ue1, count.index) : element(var.azs_ue2, count.index)}"
 
  vpc_security_group_ids = ["${aws_security_group.nodes.id}"]
  subnet_id     = "${aws_subnet.default.id}"
connection {
  user        = "${var.ssh_username}"
  private_key ="${file("/mnt/d/9068kuftyrau-ohio.pem")}"
  # private_key ="${file("/home/vkuftyrau/Downloads/kuftyrau-home.pem")}"
  agent       = true
  timeout     = "3m"
}

  # provisioner "remote-exec" {
  #   inline = [
  #     "export PATH=$PATH:/usr/bin",
  #     "sudo apt update -y",
  #     "sudo apt install -y nginx",
  #     "sudo su -c 'echo $HOSTNAME > /var/www/html/index.html'",
  #     "sudo service nginx start && sudo systemctl enable nginx"
  #   ]
  # }



  tags {
    name = "Node-${count.index}"
  }
}


resource "aws_elb" "kuftyrau_elb" {
  name               = "kuftyrau-elb"

  availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]

  depends_on         = ["aws_s3_bucket.kuftyrau_bucket"]
  security_groups    = ["${aws_security_group.lb.id}"]

  access_logs {
    bucket    = "${aws_s3_bucket.kuftyrau_bucket.bucket}"
    interval  = "5"
    enabled   = "true"
  }
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  instances = ["${aws_instance.kuftyrau_instance.*.id}"]
}