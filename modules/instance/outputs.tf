output "this_instance_id" {

  value = "${aws_instance.kuftyrau_instance.*.id}"
  
}
