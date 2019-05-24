variable "region" {
  default = "us-east-2"
}


variable "instance_count" {
  default = 2
}

variable "keyname" {
  type = "map"
  default = {
   "us-east-1" = "9068kuftyrau"
   "us-east-2" = "9068kuftyrau-ohio"
   # "us-east-2" = "kuftyrau-home"

  }
}

variable "subnet_id" {
  type = "string"
}



variable "ssh_username"{
  default = "ubuntu"
}

variable "amis" {
  type = "map"

  default = {
    "us-east-1" = "ami-0a313d6098716f372"
    "us-east-2" = "ami-0c55b159cbfafe1f0"
  }
}

variable "security_group_id" {
  type = "string"

}

