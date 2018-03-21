output "connection_id" {
  value = "${join("", aws_vpc_peering_connection.default.*.id)}"
}

output "accept_status" {
  value = "${join("", aws_vpc_peering_connection.default.*.accept_status)}"
}
