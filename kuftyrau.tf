provider "aws" {
  region  = "${var.region}"
  profile = "default"
}
data "aws_elb_service_account" "main" {}
resource "aws_s3_bucket" "kuftyrau_bucket" {
  bucket = "s3-kuftyrau"
  acl    = "log-delivery-write"
  # acl    = "private"
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


resource "aws_instance" "kuftyrau_instance" {
  # count         = "${var.instance_count}"
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"
  key_name      = "${lookup(var.keyname, var.region)}"

connection {
  user = "ubuntu"
  private_key="${file("/home/vkuftyrau/Downloads/kuftyrau-home.pem")}"
  agent = true
  timeout = "3m"
}
  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo apt update -y",
      "sudo apt install -y nginx",
      "sudo su -c 'echo $HOSTNAME > /var/www/html/index.html'",
      "sudo systemctl start nginx && sudo systemctl enable nginx"
    ]
  }
}

resource "aws_elb" "kuftyrau_elb" {
  name               = "kuftyrau-elb"
  availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]
  # depends_on = ["aws_s3_bucket.kuftyrau-bucket"]
  access_logs {
    # bucket    = "${aws_s3_bucket.kuftyrau_bucket.id}"
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
  instances = ["${aws_instance.kuftyrau_instance.id}"]
}