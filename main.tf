# Requester's side of the connection.
resource "aws_vpc_peering_connection" "default" {
  vpc_id        = "${var.vpc_id}"
  peer_vpc_id   = "${var.vpc_peer_id}"
  peer_owner_id = "${var.peer_owner_id}"
  auto_accept   = false
  accepter      = "${var.accepter}"
  requester     = "${var.requester}"

  tags {
    Side = "Requester"
  }
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "default" {
  vpc_peering_connection_id = "${local.peer_owner_id}"
  auto_accept               = true

  tags {
    Side = "Accepter"
  }
}
