output "this_instance_id" {

  value = "${aws_instance.kuftyrau_instance.*.id}"
  
}

output "this_ami" {

  value =  "${aws_instance.kuftyrau_instance.0.ami}"
  
}

output "this_az" {

  value = "${aws_instance.kuftyrau_instance.0.availability_zone}"
  
}