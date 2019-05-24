provider "aws" {
  region  = "${var.region}"
  profile = "default"
}


module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = "${var.vpc_cidr}"
  
}


module "gateway" {
  source = "./modules/gateway"
  vpc_id = "${module.vpc.this_vpc_id}"
}


module "route_table" {
  source = "./modules/route_table"
  default_route_table_id = "${module.vpc.this_default_route_table_id}"
  gateway_id = "${module.gateway.this_gateway_id}"
  
}


module "nacl" {
  source = "./modules/nacl"
  vpc_id = "${module.vpc.this_vpc_id}"
}

module "subnet" {
  source = "./modules/subnet"
  vpc_id = "${module.vpc.this_vpc_id}"
  cidr_block ="172.60.1.0/24"
  
}

module "security_groups" {
  source     = "./modules/security_groups"
  vpc_id     = "${module.vpc.this_vpc_id}"
  cidr_block = "${module.subnet.this_cidr_block}"
}


module "instance" {
  source            = "./modules/instance"
  subnet_id         = "${module.subnet.this_subnet_id}"
  security_group_id = "${module.security_groups.this_sg_nodes_id}"
}



module "bucket" {
  source = "./modules/bucket"
  region = "${var.region}"
}

module "elb" {
  source = "./modules/elb"
  subnet_id = "${module.subnet.this_subnet_id}"
  security_group_id = "${module.security_groups.this_sg_lb_id}"
  bucket = "${module.bucket.this_bucket}"
  instance_id = "${module.instance.this_instance_id}"
}

module "autoscaling" {
  source             = "./modules/autoscaling"
  ami                = "${module.instance.this_ami}"
  security_group_id  = "${module.security_groups.this_sg_nodes_id}"
  az                 = "${module.instance.this_az}"
  min_instance_count = 2
  max_instance_count = 3
  elb_name           = "${module.elb.this_name}"
  subnet_id          = "${module.subnet.this_subnet_id}"

}
