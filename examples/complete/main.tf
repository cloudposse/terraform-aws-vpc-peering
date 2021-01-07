provider "aws" {
  region = var.region
}

module "requestor_vpc" {
  source     = "cloudposse/vpc/aws"
  version    = "0.18.1"
  attributes = ["requestor"]
  cidr_block = var.requestor_vpc_cidr

  context = module.this.context
}

module "requestor_subnets" {
  source               = "cloudposse/dynamic-subnets/aws"
  version              = "0.33.0"
  availability_zones   = var.availability_zones
  attributes           = ["requestor"]
  vpc_id               = module.requestor_vpc.vpc_id
  igw_id               = module.requestor_vpc.igw_id
  cidr_block           = module.requestor_vpc.vpc_cidr_block
  nat_gateway_enabled  = false
  nat_instance_enabled = false

  context = module.this.context
}

module "acceptor_vpc" {
  source     = "cloudposse/vpc/aws"
  version    = "0.18.1"
  attributes = ["acceptor"]
  cidr_block = var.acceptor_vpc_cidr

  context = module.this.context
}

module "acceptor_subnets" {
  source               = "cloudposse/dynamic-subnets/aws"
  version              = "0.33.0"
  availability_zones   = var.availability_zones
  attributes           = ["acceptor"]
  vpc_id               = module.acceptor_vpc.vpc_id
  igw_id               = module.acceptor_vpc.igw_id
  cidr_block           = module.acceptor_vpc.vpc_cidr_block
  nat_gateway_enabled  = false
  nat_instance_enabled = false

  context = module.this.context
}

module "vpc_peering" {
  source                                    = "../.."
  auto_accept                               = true
  requestor_allow_remote_vpc_dns_resolution = true
  acceptor_allow_remote_vpc_dns_resolution  = true
  requestor_vpc_id                          = module.requestor_vpc.vpc_id
  acceptor_vpc_id                           = module.acceptor_vpc.vpc_id
  create_timeout                            = "5m"
  update_timeout                            = "5m"
  delete_timeout                            = "10m"

  context = module.this.context
}
