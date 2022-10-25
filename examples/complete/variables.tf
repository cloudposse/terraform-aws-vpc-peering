variable "region" {
  type        = string
  description = "AWS Region"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "requestor_vpc_cidr" {
  type        = string
  description = "Requestor VPC CIDR"
}

variable "acceptor_vpc_cidr" {
  type        = string
  description = "Acceptor VPC CIDR"
}

variable "requestor_additional_ipv4_cidr_block" {
  description = "An additional IPv4 CIDR block to associate with the VPC"
  type        = string
}
