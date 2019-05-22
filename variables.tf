variable "region" {
  default = "us-east-2"
}

variable "vpc_cidr" {
  default = "172.31.0.0/16"
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


variable "elb_az" {
type= "map"
  default = {
    "us-east-1" = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1e"]
    "us-east-2" = ["us-east-2a", "us-east-2b", "us-east-2c"]
  }
}



variable "azs_ue2" {
  default = ["us-east-2a", "us-east-2b", "us-east-2c"]
}
variable "azs_ue1" {
  default =  ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1e"]
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
