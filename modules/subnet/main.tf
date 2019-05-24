resource "aws_subnet" "default" {
  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "${var.cidr_block}"
  map_public_ip_on_launch = true
}