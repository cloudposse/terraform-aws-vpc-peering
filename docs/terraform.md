<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| aws | >= 2.0 |
| local | >= 1.3 |
| template | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| acceptor\_allow\_remote\_vpc\_dns\_resolution | Allow acceptor VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the requestor VPC | `bool` | `true` | no |
| acceptor\_cidr\_block\_associations | Only add these acceptor VPC CIDR block associations to reqeustor VPC route tables | `list(string)` | `[]` | no |
| acceptor\_route\_table\_tags | Only add peer routes to acceptor VPC route tables matching these tags | `map(string)` | `{}` | no |
| acceptor\_vpc\_id | Acceptor VPC ID | `string` | `""` | no |
| acceptor\_vpc\_tags | Acceptor VPC tags | `map(string)` | `{}` | no |
| additional\_tag\_map | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| auto\_accept | Automatically accept the peering (both VPCs need to be in the same AWS account) | `bool` | `true` | no |
| context | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| create\_timeout | VPC peering connection create timeout. For more details, see https://www.terraform.io/docs/configuration/resources.html#operation-timeouts | `string` | `"3m"` | no |
| delete\_timeout | VPC peering connection delete timeout. For more details, see https://www.terraform.io/docs/configuration/resources.html#operation-timeouts | `string` | `"5m"` | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| environment | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| id\_length\_limit | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| label\_key\_case | The letter case of label keys (`tag` names) (i.e. `name`, `namespace`, `environment`, `stage`, `attributes`) to use in `tags`.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| label\_order | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| label\_value\_case | The letter case of output label values (also used in `tags` and `id`).<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Default value: `lower`. | `string` | `null` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| regex\_replace\_chars | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| requestor\_allow\_remote\_vpc\_dns\_resolution | Allow requestor VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the acceptor VPC | `bool` | `true` | no |
| requestor\_cidr\_block\_associations | Only add these requestor VPC CIDR block associations to acceptor VPC route tables | `list(string)` | `[]` | no |
| requestor\_route\_table\_tags | Only add peer routes to requestor VPC route tables matching these tags | `map(string)` | `{}` | no |
| requestor\_vpc\_id | Requestor VPC ID | `string` | `""` | no |
| requestor\_vpc\_tags | Requestor VPC tags | `map(string)` | `{}` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| update\_timeout | VPC peering connection update timeout. For more details, see https://www.terraform.io/docs/configuration/resources.html#operation-timeouts | `string` | `"3m"` | no |

## Outputs

| Name | Description |
|------|-------------|
| accept\_status | The status of the VPC peering connection request |
| connection\_id | VPC peering connection ID |

<!-- markdownlint-restore -->
