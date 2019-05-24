output "this_cidr_block" {

  value = "${aws_subnet.default.cidr_block}"
  
}

output "this_subnet_id" {

  value = "${aws_subnet.default.id}"
  
}