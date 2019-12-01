package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Test the Terraform module in examples/complete using Terratest.
func TestExamplesComplete(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-east-2.tfvars"},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

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
}
