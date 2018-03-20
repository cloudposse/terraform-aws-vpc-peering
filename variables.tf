variable "enabled" {
  default     = "true"
  description = "Set to false to prevent the module from creating or accessing any resources"
}

variable "requestor_vpc_id" {
  type        = "string"
  description = "Requestor VPC ID"
}

variable "acceptor_vpc_id" {
  type        = "string"
  description = "Acceptor VPC ID"
}

variable "auto_accept" {
  default     = "true"
  description = "Automatically accept the peering (both VPCs need to be in the same AWS account)"
}

variable "namespace" {
  description = "Namespace (e.g. `cp` or `cloudposse`)"
  type        = "string"
}

variable "stage" {
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
  type        = "string"
}

variable "name" {
  description = "Name  (e.g. `app` or `cluster`)"
  type        = "string"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name`, and `attributes`"
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `policy` or `role`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map('BusinessUnit`,`XYZ`)"
}
