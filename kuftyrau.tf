provider "aws" {
  region  = "${var.region}"
  profile = "default"
}

resource "aws_instance" "kuftyrau_instance" {
  count         = "${var.instance_count}"
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"
  key_name      = "${lookup(var.keyname, var.region)}"
  provisioner "remote-exec" {
    inline = [
    "echo 123 > /home/ubuntu/ip_address.txt",
    ]
  }
}

resource "aws_s3_bucket" "kuftyrau-bucket" {
  bucket = "s3-kuftyrau"
  acl    = "private"
  region = "${var.region}"
}

