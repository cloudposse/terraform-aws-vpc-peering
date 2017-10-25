output "peering_id" {
  description = "The ID of the VPC Peering Connection"
  value       = "${aws_vpc_peering_connection.default.id}"
}

output "peering_status" {
  description = "The status of the VPC Peering Connection request"
  value       = "${aws_vpc_peering_connection.default.accept_status}"
}
