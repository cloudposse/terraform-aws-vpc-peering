provider "aws" {
  region = var.region
}

module "requestor_vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.8.1"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  attributes = concat(var.attributes, ["requestor"])
  cidr_block = var.requestor_vpc_cidr
  tags       = var.tags
}

module "requestor_subnets" {
  source               = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=tags/0.18.1"
  availability_zones   = var.availability_zones
  namespace            = var.namespace
  stage                = var.stage
  name                 = var.name
  attributes           = concat(var.attributes, ["requestor"])
  vpc_id               = module.requestor_vpc.vpc_id
  igw_id               = module.requestor_vpc.igw_id
  cidr_block           = module.requestor_vpc.vpc_cidr_block
  nat_gateway_enabled  = false
  nat_instance_enabled = false
  tags                 = var.tags
}

module "acceptor_vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.8.1"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  attributes = concat(var.attributes, ["acceptor"])
  cidr_block = var.acceptor_vpc_cidr
  tags       = var.tags
}

module "acceptor_subnets" {
  source               = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=tags/0.18.1"
  availability_zones   = var.availability_zones
  namespace            = var.namespace
  stage                = var.stage
  name                 = var.name
  attributes           = concat(var.attributes, ["acceptor"])
  vpc_id               = module.acceptor_vpc.vpc_id
  igw_id               = module.acceptor_vpc.igw_id
  cidr_block           = module.acceptor_vpc.vpc_cidr_block
  nat_gateway_enabled  = false
  nat_instance_enabled = false
  tags                 = var.tags
}

module "vpc_peering" {
  source                                    = "../.."
  namespace                                 = var.namespace
  stage                                     = var.stage
  name                                      = var.name
  attributes                                = var.attributes
  tags                                      = var.tags
  auto_accept                               = true
  requestor_allow_remote_vpc_dns_resolution = true
  acceptor_allow_remote_vpc_dns_resolution  = true
  requestor_vpc_id                          = module.requestor_vpc.vpc_id
  acceptor_vpc_id                           = module.acceptor_vpc.vpc_id
  create_timeout                            = "5m"
  update_timeout                            = "5m"
  delete_timeout                            = "10m"
}
