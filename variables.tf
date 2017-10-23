variable "peer_owner_id" {
  description = "The AWS account ID of the owner of the peer VPC"
}

variable "vpc_id" {
  description = "The ID of the requester VPC"
}

variable "vpc_peer_id" {
  default = "The ID of the VPC with which you are creating the VPC Peering Connection"
}

variable "requester" {
  description = ""
  type        = "map"

  default = {
    allow_remote_vpc_dns_resolution = true
  }
}

variable "accepter" {
  description = ""
  type        = "map"

  default = {
    allow_remote_vpc_dns_resolution = true
  }
}
