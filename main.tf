locals {
  accepter_route_tables = "${coalescelist(distinct(sort(data.aws_route_table.accepter.*.route_table_id)), var.route_tables)}"
}

# Requester's side of the connection.
resource "aws_vpc_peering_connection" "default" {
  vpc_id        = "${var.vpc_id}"
  peer_vpc_id   = "${var.vpc_peer_id}"
  peer_owner_id = "${var.peer_owner_id}"
  auto_accept   = "${var.auto_accept}"
  accepter      = "${var.accepter}"
  requester     = "${var.requester}"

  tags {
    Side = "Requester"
  }
}

###
data "aws_vpc_peering_connection" "default" {
  vpc_id     = "${var.vpc_id}"
  depends_on = ["aws_vpc_peering_connection.default"]
}

## requester
data "aws_vpc" "requester" {
  id = "${var.vpc_id}"
}

data "aws_subnet_ids" "requester" {
  vpc_id = "${var.vpc_id}"
}

data "aws_route_table" "requester" {
  count     = "${length(distinct(sort(data.aws_subnet_ids.requester.ids)))}"
  subnet_id = "${element(data.aws_subnet_ids.requester.ids, count.index)}"
}

## accepter
data "aws_vpc" "accepter" {
  count = "${var.same_account == "true" ? 1 : 0}"
  id    = "${var.vpc_peer_id}"
}

data "aws_subnet_ids" "accepter" {
  count  = "${var.same_account == "true" ? 1 : 0}"
  vpc_id = "${var.vpc_peer_id}"
}

data "aws_route_table" "accepter" {
  count     = "${length(distinct(sort(data.aws_subnet_ids.accepter.ids)))}"
  subnet_id = "${element(coalescelist(data.aws_subnet_ids.accepter.ids, list("workaround")), count.index)}"
}

resource "aws_route" "requester" {
  count                     = "${length(compact(concat(data.aws_route_table.requester.*.route_table_id, list(""))))}"
  route_table_id            = "${element(data.aws_route_table.requester.*.route_table_id, count.index)}"
  destination_cidr_block    = "${data.aws_vpc_peering_connection.default.peer_cidr_block}"
  vpc_peering_connection_id = "${data.aws_vpc_peering_connection.default.id}"
}

resource "aws_route" "accepter" {
  count                     = "${length(local.accepter_route_tables)}"
  route_table_id            = "${element(local.accepter_route_tables, count.index)}"
  destination_cidr_block    = "${data.aws_vpc_peering_connection.default.cidr_block}"
  vpc_peering_connection_id = "${data.aws_vpc_peering_connection.default.id}"
  depends_on                = ["data.aws_route_table.accepter"]
}
