output "requestor_vpc_cidr" {
  value       = module.requestor_vpc.vpc_cidr_block
  description = "Requestor VPC ID"
}

output "requestor_public_subnet_cidrs" {
  value       = module.requestor_subnets.public_subnet_cidrs
  description = "Requestor public subnet CIDRs"
}

output "requestor_private_subnet_cidrs" {
  value       = module.requestor_subnets.private_subnet_cidrs
  description = "Requestor private subnet CIDRs"
}

output "acceptor_vpc_cidr" {
  value       = module.acceptor_vpc.vpc_cidr_block
  description = "Acceptor VPC ID"
}

output "acceptor_public_subnet_cidrs" {
  value       = module.acceptor_subnets.public_subnet_cidrs
  description = "Acceptor public subnet CIDRs"
}

output "acceptor_private_subnet_cidrs" {
  value       = module.acceptor_subnets.private_subnet_cidrs
  description = "Acceptor private subnet CIDRs"
}

output "connection_id" {
  value       = module.vpc_peering.connection_id
  description = "VPC peering connection ID"
}

output "accept_status" {
  value       = module.vpc_peering.accept_status
  description = "The status of the VPC peering connection request"
}
