variable "peer_owner_id" {
  description = "The AWS account ID of the owner of the peer VPC"
  default     = ""
}

variable "vpc_id" {
  description = "The ID of the requester VPC"
}

variable "vpc_peer_id" {
  default = "The ID of the VPC with which you are creating the VPC Peering Connection"
}

variable "same_account" {
  default = "true"
}

variable "auto_accept" {
  default = "true"
}

variable "requester" {
  description = ""
  type        = "list"

  default = [
    {
      allow_remote_vpc_dns_resolution = true
    },
  ]
}

variable "accepter" {
  description = ""
  type        = "list"

  default = [
    {
      allow_remote_vpc_dns_resolution = true
    },
  ]
}

variable "route_tables" {
  type    = "list"
  default = []
}
