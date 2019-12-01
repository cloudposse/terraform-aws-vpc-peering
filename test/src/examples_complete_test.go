package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Test the Terraform module in examples/complete using Terratest.
func TestExamplesComplete(t *testing.T) {
	t.Parallel()

	// We need to create the ALB first because terraform does not wwait for it to be in the ready state before creating ECS target group
	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-east-2.tfvars"},
		Targets:  []string{"module.requestor_vpc", "module.requestor_subnets", "module.acceptor_vpc", "module.acceptor_subnets"},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer func() {
		if r := recover(); r != nil {
			terraformOptions.Targets = []string{"module.vpc_peering"}
			terraform.Destroy(t, terraformOptions)
			terraformOptions.Targets = nil
			terraform.Destroy(t, terraformOptions)
			assert.Fail(t, fmt.Sprintf("Panicked: %v", r))
		} else {
			terraformOptions.Targets = []string{"module.vpc_peering"}
			terraform.Destroy(t, terraformOptions)
			terraformOptions.Targets = nil
			terraform.Destroy(t, terraformOptions)
		}
	}()

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	terraformOptions.Targets = nil

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.Apply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	requestorVpcCidr := terraform.Output(t, terraformOptions, "requestor_vpc_cidr")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "172.16.0.0/16", requestorVpcCidr)

	// Run `terraform output` to get the value of an output variable
	requestorPrivateSubnetCidrs := terraform.OutputList(t, terraformOptions, "requestor_private_subnet_cidrs")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, []string{"172.16.0.0/19", "172.16.32.0/19"}, requestorPrivateSubnetCidrs)

	// Run `terraform output` to get the value of an output variable
	requestorPublicSubnetCidrs := terraform.OutputList(t, terraformOptions, "requestor_public_subnet_cidrs")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, []string{"172.16.96.0/19", "172.16.128.0/19"}, requestorPublicSubnetCidrs)

	// Run `terraform output` to get the value of an output variable
	acceptorVpcCidr := terraform.Output(t, terraformOptions, "acceptor_vpc_cidr")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "172.32.0.0/16", acceptorVpcCidr)

	// Run `terraform output` to get the value of an output variable
	acceptorPrivateSubnetCidrs := terraform.OutputList(t, terraformOptions, "acceptor_private_subnet_cidrs")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, []string{"172.32.0.0/19", "172.32.32.0/19"}, acceptorPrivateSubnetCidrs)

	// Run `terraform output` to get the value of an output variable
	acceptorPublicSubnetCidrs := terraform.OutputList(t, terraformOptions, "acceptor_public_subnet_cidrs")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, []string{"172.32.96.0/19", "172.32.128.0/19"}, acceptorPublicSubnetCidrs)

	// Run `terraform output` to get the value of an output variable
	connectionId := terraform.Output(t, terraformOptions, "connection_id")
	// Verify we're getting back the outputs we expect
	assert.Contains(t, connectionId, "pcx-")

	// Run `terraform output` to get the value of an output variable
	acceptStatus := terraform.Output(t, terraformOptions, "accept_status")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "active", acceptStatus)
}
