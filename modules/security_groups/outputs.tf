output "this_sg_nodes_id" {

  value = "${aws_security_group.nodes.id}"
  
}

output "this_sg_lb_id" {

  value = "${aws_security_group.lb.id}"
  
}