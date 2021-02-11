resource "aws_vpc_peering_connection" "default" {
  count       = module.this.enabled ? 1 : 0
  vpc_id      = join("", data.aws_vpc.requestor.*.id)
  peer_vpc_id = join("", data.aws_vpc.acceptor.*.id)

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
  count  = module.this.enabled ? 1 : 0
  vpc_id = join("", data.aws_vpc.requestor.*.id)
  tags   = var.requestor_route_table_tags
}

data "aws_route_tables" "acceptor" {
  count  = module.this.enabled ? 1 : 0
  vpc_id = join("", data.aws_vpc.acceptor.*.id)
  tags   = var.acceptor_route_table_tags
}

# Create routes from requestor to acceptor
resource "aws_route" "requestor" {
  count                     = module.this.enabled && var.requestor_routes_create ? length(distinct(sort(data.aws_route_tables.requestor.0.ids))) * length(data.aws_vpc.acceptor.0.cidr_block_associations) : 0
  route_table_id            = element(distinct(sort(data.aws_route_tables.requestor.0.ids)), ceil(count.index / length(data.aws_vpc.acceptor.0.cidr_block_associations)))
  destination_cidr_block    = data.aws_vpc.acceptor.0.cidr_block_associations[count.index % length(data.aws_vpc.acceptor.0.cidr_block_associations)]["cidr_block"]
  vpc_peering_connection_id = join("", aws_vpc_peering_connection.default.*.id)
  depends_on                = [data.aws_route_tables.requestor, aws_vpc_peering_connection.default]
}

# Create routes from acceptor to requestor
resource "aws_route" "acceptor" {
  count                     = module.this.enabled && var.acceptor_routes_create ? length(distinct(sort(data.aws_route_tables.acceptor.0.ids))) * length(data.aws_vpc.requestor.0.cidr_block_associations) : 0
  route_table_id            = element(distinct(sort(data.aws_route_tables.acceptor.0.ids)), ceil(count.index / length(data.aws_vpc.requestor.0.cidr_block_associations)))
  destination_cidr_block    = data.aws_vpc.requestor.0.cidr_block_associations[count.index % length(data.aws_vpc.requestor.0.cidr_block_associations)]["cidr_block"]
  vpc_peering_connection_id = join("", aws_vpc_peering_connection.default.*.id)
  depends_on                = [data.aws_route_tables.acceptor, aws_vpc_peering_connection.default]
}
