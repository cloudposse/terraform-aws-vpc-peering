variable "requestor_vpc_id" {
  type        = string
  description = "Requestor VPC ID"
  default     = ""
}

variable "requestor_vpc_tags" {
  type        = map(string)
  description = "Requestor VPC tags"
  default     = {}
}

variable "requestor_route_table_tags" {
  type        = map(string)
  description = "Only add peer routes to requestor VPC route tables matching these tags"
  default     = {}
}

variable "acceptor_vpc_id" {
  type        = string
  description = "Acceptor VPC ID"
  default     = ""
}

variable "acceptor_vpc_tags" {
  type        = map(string)
  description = "Acceptor VPC tags"
  default     = {}
}

variable "acceptor_route_table_tags" {
  type        = map(string)
  description = "Only add peer routes to acceptor VPC route tables matching these tags"
  default     = {}
}

variable "auto_accept" {
  type        = bool
  default     = true
  description = "Automatically accept the peering (both VPCs need to be in the same AWS account)"
}

variable "acceptor_allow_remote_vpc_dns_resolution" {
  type        = bool
  default     = true
  description = "Allow acceptor VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the requestor VPC"
}

variable "requestor_allow_remote_vpc_dns_resolution" {
  type        = bool
  default     = true
  description = "Allow requestor VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the acceptor VPC"
}

variable "create_timeout" {
  type        = string
  description = "VPC peering connection create timeout. For more details, see https://www.terraform.io/docs/configuration/resources.html#operation-timeouts"
  default     = "3m"
}

variable "update_timeout" {
  type        = string
  description = "VPC peering connection update timeout. For more details, see https://www.terraform.io/docs/configuration/resources.html#operation-timeouts"
  default     = "3m"
}

variable "delete_timeout" {
  type        = string
  description = "VPC peering connection delete timeout. For more details, see https://www.terraform.io/docs/configuration/resources.html#operation-timeouts"
  default     = "5m"
}

variable "requestor_ignore_cidrs" {
  type        = list(string)
  description = "A list of CIDR blocks from the requestor VPC to ignore"
  default     = []
}

variable "acceptor_ignore_cidrs" {
  type        = list(string)
  description = "A list of CIDR blocks from the acceptor VPC to ignore"
  default     = []
}
