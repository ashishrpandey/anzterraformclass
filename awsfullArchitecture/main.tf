provider "aws" {
  region = "${var.aws_region}"
}

# Deploy Storage Resource
module "storage" {
  source       = "./storage"
  project_name = "${var.project_name}"
}

# Deploy Networking Resources

module "networking" {
  source       = "github.com/modules/networking"
  version = 1.3.0 
  vpc_cidr     = "${var.vpc_cidr}"
  public_cidrs = "${var.public_cidrs}"
  accessip     = "${var.accessip}"
}

# Deploy Compute Resources

module "compute" {
  source          = "./compute"
  instance_count  = "${var.instance_count}"
  key_name        = "${var.key_name}"
  public_key_path = "${var.public_key_path}"
  instance_type   = "${var.server_instance_type}"
  #subnets         = "${module.networking.public_subnet}"
  subnets         = ["${module.networking.public_subnet}","${module.networking.private_subnet}"]
  security_group  = "${module.networking.public_sg}"
  subnet_ips      = "${var.public_cidrs}"
}
