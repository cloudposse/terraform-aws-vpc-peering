provider "aws" {
  region = var.region
}

module "requestor_vpc" {
  source                  = "cloudposse/vpc/aws"
  version                 = "2.3.0"
  attributes              = ["requestor"]
  ipv4_primary_cidr_block = var.requestor_vpc_cidr
  ipv4_additional_cidr_block_associations = {
    (var.requestor_additional_ipv4_cidr_block) = {
      ipv4_cidr_block     = var.requestor_additional_ipv4_cidr_block
      ipv4_ipam_pool_id   = null
      ipv4_netmask_length = null
    }
  }

  context = module.this.context
}

module "requestor_subnets" {
  source              = "cloudposse/dynamic-subnets/aws"
  version             = "2.4.2"
  availability_zones  = var.availability_zones
  attributes          = ["requestor"]
  vpc_id              = module.requestor_vpc.vpc_id
  igw_id              = [module.requestor_vpc.igw_id]
  ipv4_cidr_block     = [module.requestor_vpc.vpc_cidr_block]
  nat_gateway_enabled = false

  context = module.this.context
}

module "requestor_subnets_additional" {
  source                 = "cloudposse/dynamic-subnets/aws"
  version                = "2.4.2"
  availability_zones     = var.availability_zones
  attributes             = ["requestor"]
  vpc_id                 = module.requestor_vpc.vpc_id
  igw_id                 = [module.requestor_vpc.igw_id]
  ipv4_cidr_block        = [var.requestor_additional_ipv4_cidr_block]
  nat_gateway_enabled    = false
  public_subnets_enabled = false

  context = module.this.context

  # necessary for clean destory, see open issue: https://github.com/hashicorp/terraform-provider-aws/issues/9592
  depends_on = [module.requestor_vpc]
}

module "acceptor_vpc" {
  source                  = "cloudposse/vpc/aws"
  version                 = "2.3.0"
  attributes              = ["acceptor"]
  ipv4_primary_cidr_block = var.acceptor_vpc_cidr

  context = module.this.context
}

module "acceptor_subnets" {
  source              = "cloudposse/dynamic-subnets/aws"
  version             = "2.4.2"
  availability_zones  = var.availability_zones
  attributes          = ["acceptor"]
  vpc_id              = module.acceptor_vpc.vpc_id
  igw_id              = [module.acceptor_vpc.igw_id]
  ipv4_cidr_block     = [module.acceptor_vpc.vpc_cidr_block]
  nat_gateway_enabled = false

  context = module.this.context
}

module "vpc_peering" {
  source                                    = "../.."
  auto_accept                               = true
  requestor_allow_remote_vpc_dns_resolution = true
  acceptor_allow_remote_vpc_dns_resolution  = true
  acceptor_cidr_blocks                      = [var.acceptor_vpc_cidr]
  acceptor_route_table_ids = concat(
    module.acceptor_subnets.private_route_table_ids,
    module.acceptor_subnets.public_route_table_ids,
    [module.acceptor_vpc.vpc_default_route_table_id]
  )
  acceptor_vpc_id       = module.acceptor_vpc.vpc_id
  requestor_cidr_blocks = [var.requestor_vpc_cidr, var.requestor_additional_ipv4_cidr_block]
  requestor_route_table_ids = concat(
    module.requestor_subnets.private_route_table_ids,
    module.requestor_subnets_additional.private_route_table_ids,
    module.requestor_subnets.public_route_table_ids,
    module.requestor_subnets_additional.public_route_table_ids,
    [module.requestor_vpc.vpc_default_route_table_id]
  )
  requestor_ignore_cidrs = [var.requestor_additional_ipv4_cidr_block]
  requestor_vpc_id       = module.requestor_vpc.vpc_id
  create_timeout         = "5m"
  update_timeout         = "5m"
  delete_timeout         = "10m"

  context = module.this.context
}
