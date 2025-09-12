resource "aws_vpc_peering_connection" "default" {
  count       = module.this.enabled ? 1 : 0
  vpc_id      = join("", data.aws_vpc.requestor[*].id)
  peer_vpc_id = join("", data.aws_vpc.acceptor[*].id)

  auto_accept = var.auto_accept

  accepter {
    allow_remote_vpc_dns_resolution = var.acceptor_allow_remote_vpc_dns_resolution
  }

  requester {
    allow_remote_vpc_dns_resolution = var.requestor_allow_remote_vpc_dns_resolution
  }

  tags = module.this.tags

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}

# Lookup requestor VPC so that we can reference the CIDR
data "aws_vpc" "requestor" {
  count = module.this.enabled ? 1 : 0
  id    = var.requestor_vpc_id
  tags  = var.requestor_vpc_tags
}

# Lookup acceptor VPC so that we can reference the CIDR
data "aws_vpc" "acceptor" {
  count = module.this.enabled ? 1 : 0
  id    = var.acceptor_vpc_id
  tags  = var.acceptor_vpc_tags
}

data "aws_route_tables" "requestor" {
  count  = module.this.enabled && length(var.requestor_route_table_ids) == 0 ? 1 : 0
  vpc_id = join("", data.aws_vpc.requestor[*].id)
  tags   = var.requestor_route_table_tags
}

data "aws_route_tables" "acceptor" {
  count  = module.this.enabled && length(var.acceptor_route_table_ids) == 0 ? 1 : 0
  vpc_id = join("", data.aws_vpc.acceptor[*].id)
  tags   = var.acceptor_route_table_tags
}

locals {
  # List of CIDR blocks for the requestor VPC, excluding any ignored CIDRs
  requestor_cidr_blocks = module.this.enabled ? (
    length(var.requestor_cidr_blocks) == 0 ? (
      tolist(setsubtract(data.aws_vpc.requestor[0].cidr_block_associations[*].cidr_block, var.requestor_ignore_cidrs))
    ) : tolist(setsubtract(var.requestor_cidr_blocks, var.requestor_ignore_cidrs))
  ) : []

  # List of route table IDs for the requestor VPC, either discovered or provided
  requestor_route_table_ids = module.this.enabled ? (
    length(var.requestor_route_table_ids) == 0 ? distinct(data.aws_route_tables.requestor[0].ids) : var.requestor_route_table_ids
  ) : []


  # List of CIDR blocks for the acceptor VPC, excluding any ignored CIDRs
  acceptor_cidr_blocks = module.this.enabled ? (
    length(var.acceptor_cidr_blocks) == 0 ? (
      tolist(setsubtract(data.aws_vpc.acceptor[0].cidr_block_associations[*].cidr_block, var.acceptor_ignore_cidrs))
    ) : tolist(setsubtract(var.acceptor_cidr_blocks, var.acceptor_ignore_cidrs))
  ) : []

  # List of route table IDs for the acceptor VPC, either discovered or provided
  acceptor_route_table_ids = module.this.enabled ? (
    length(var.acceptor_route_table_ids) == 0 ? distinct(data.aws_route_tables.acceptor[0].ids) : var.acceptor_route_table_ids
  ) : []

  # Cartesian product of route table IDs and CIDR blocks for both requestor and acceptor
  requestor_route_cidr_mapper = module.this.enabled ? tolist(setproduct(local.requestor_route_table_ids, local.acceptor_cidr_blocks)) : []
  acceptor_route_cidr_mapper  = module.this.enabled ? tolist(setproduct(local.acceptor_route_table_ids, local.requestor_cidr_blocks)) : []
}

# Create routes from requestor to acceptor
resource "aws_route" "requestor" {
  # Using count instead of for_each to maintain compatibility with previous versions
  count                     = length(local.requestor_route_cidr_mapper)
  route_table_id            = local.requestor_route_cidr_mapper[count.index][0]
  destination_cidr_block    = local.requestor_route_cidr_mapper[count.index][1]
  vpc_peering_connection_id = join("", aws_vpc_peering_connection.default[*].id)
  depends_on                = [data.aws_route_tables.requestor, aws_vpc_peering_connection.default]
}

# Create routes from acceptor to requestor
resource "aws_route" "acceptor" {
  # Using count instead of for_each to maintain compatibility with previous versions
  count                     = length(local.acceptor_route_cidr_mapper)
  route_table_id            = local.acceptor_route_cidr_mapper[count.index][0]
  destination_cidr_block    = local.acceptor_route_cidr_mapper[count.index][1]
  vpc_peering_connection_id = join("", aws_vpc_peering_connection.default[*].id)
  depends_on                = [data.aws_route_tables.acceptor, aws_vpc_peering_connection.default]
}
