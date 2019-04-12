## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| acceptor_allow_remote_vpc_dns_resolution | Allow acceptor VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the requestor VPC | string | `true` | no |
| acceptor_vpc_id | Acceptor VPC ID | string | `` | no |
| acceptor_vpc_tags | Acceptor VPC tags | map | `<map>` | no |
| attributes | Additional attributes (e.g. `policy` or `role`) | list | `<list>` | no |
| auto_accept | Automatically accept the peering (both VPCs need to be in the same AWS account) | string | `true` | no |
| delimiter | Delimiter to be used between `namespace`, `stage`, `name`, and `attributes` | string | `-` | no |
| enabled | Set to false to prevent the module from creating or accessing any resources | string | `true` | no |
| name | Name  (e.g. `app` or `cluster`) | string | - | yes |
| namespace | Namespace (e.g. `cp` or `cloudposse`) | string | - | yes |
| requestor_allow_remote_vpc_dns_resolution | Allow requestor VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the acceptor VPC | string | `true` | no |
| requestor_vpc_id | Requestor VPC ID | string | `` | no |
| requestor_vpc_tags | Requestor VPC tags | map | `<map>` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | string | - | yes |
| tags | Additional tags (e.g. map('BusinessUnit`,`XYZ`) | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| accept_status | The status of the VPC peering connection request |
| connection_id | VPC peering connection ID |

