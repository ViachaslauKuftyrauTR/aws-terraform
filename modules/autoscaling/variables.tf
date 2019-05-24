variable "security_group_id" {
  type = "string"

}

variable "ami" {
  type = "string"

}

variable "min_instance_count" {
  type = "string"
  default = 2
}

variable "max_instance_count" {
  type = "string"
  default = 2
}

variable "az" {
  type = "string"
}

variable "elb_name" {
  type = "string"
}

variable "subnet_id" {
  type = "string"

}