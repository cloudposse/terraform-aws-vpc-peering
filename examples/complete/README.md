# terraform-aws-vpc-peering: example/complete.

This example creates the following resources:
- requestor vpc, subnets, additional subnets. 
- acceptor vpc, subnets.
- vpc peering connection between requestor vpc and acceptor vpc. 

Note:
- module.vpc_peering requires requestor_vpc and acceptor_vpc and itself resources
  to be provisioned prior to calling module.vpc_peering. 
  
# how to run the example:

- terraform init.
- terraform apply -var-file=fixtures.us-east-2.tfvars -target=module.requestor_vpc
- terraform apply -var-file=fixtures.us-east-2.tfvars -target=module.requestor_subnets
- terraform apply -var-file=fixtures.us-east-2.tfvars -target=module.requestor_subnets_additional
- terraform apply -var-file=fixtures.us-east-2.tfvars -target=module.acceptor_vpc
- terraform apply -var-file=fixtures.us-east-2.tfvars -target=module.acceptor_subnets
- terraform apply -var-file=fixtures.us-east-2.tfvars -target=module.vpc_peering