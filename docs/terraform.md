## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| acceptor_allow_remote_vpc_dns_resolution | Allow acceptor VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the requestor VPC | bool | `true` | no |
| acceptor_vpc_id | Acceptor VPC ID | string | `` | no |
| acceptor_vpc_tags | Acceptor VPC tags | map(string) | `<map>` | no |
| attributes | Additional attributes (e.g. `1`) | list(string) | `<list>` | no |
| auto_accept | Automatically accept the peering (both VPCs need to be in the same AWS account) | bool | `true` | no |
| create_timeout | VPC peering connection create timeout. For more details, see https://www.terraform.io/docs/configuration/resources.html#operation-timeouts | string | `3m` | no |
| delete_timeout | VPC peering connection delete timeout. For more details, see https://www.terraform.io/docs/configuration/resources.html#operation-timeouts | string | `5m` | no |
| delimiter | Delimiter to be used between `name`, `namespace`, `stage`, etc. | string | `-` | no |
| enabled | Set to false to prevent the module from creating or accessing any resources | bool | `true` | no |
| name | Solution name, e.g. 'app' or 'cluster' | string | - | yes |
| namespace | Namespace, which could be your organization name, e.g. 'eg' or 'cp' | string | `` | no |
| requestor_allow_remote_vpc_dns_resolution | Allow requestor VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the acceptor VPC | bool | `true` | no |
| requestor_vpc_id | Requestor VPC ID | string | `` | no |
| requestor_vpc_tags | Requestor VPC tags | map(string) | `<map>` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', or 'test' | string | `` | no |
| tags | Additional tags (e.g. `map('BusinessUnit`,`XYZ`) | map(string) | `<map>` | no |
| update_timeout | VPC peering connection update timeout. For more details, see https://www.terraform.io/docs/configuration/resources.html#operation-timeouts | string | `3m` | no |

## Outputs

| Name | Description |
|------|-------------|
| accept_status | The status of the VPC peering connection request |
| connection_id | VPC peering connection ID |

