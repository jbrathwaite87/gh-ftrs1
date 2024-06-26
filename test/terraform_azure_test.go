package test

import (
	"testing"
	"github.com/stretchr/testify/assert"
	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"os"
)

func TestAzureResources(t *testing.T) {
	t.Parallel()

	subscriptionID := os.Getenv("ARM_SUBSCRIPTION_ID")
	resourceGroupName := os.Getenv("AZURE_RESOURCE_GROUP_NAME")

	terraformOptions := &terraform.Options{
		TerraformDir: "../deployment_files/dev", // Adjust as necessary
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Test for Resource Group
	rg := azure.GetResourceGroup(t, resourceGroupName, subscriptionID)
	assert.NotNil(t, rg)

	// Test for Storage Account
	storageAccountName := terraform.Output(t, terraformOptions, "storage_account_name")
	storageAccount := azure.GetStorageAccount(t, storageAccountName, resourceGroupName, subscriptionID)
	assert.NotNil(t, storageAccount)

	// Test for Virtual Network
	vnetName := terraform.Output(t, terraformOptions, "vnet_name")
	vnet := azure.GetVirtualNetwork(t, vnetName, resourceGroupName, subscriptionID)
	assert.NotNil(t, vnet)

	// Test for Virtual Machine
	vmName := terraform.Output(t, terraformOptions, "vm_name")
	vm := azure.GetVirtualMachine(t, vmName, resourceGroupName, subscriptionID)
	assert.NotNil(t, vm)

	// Test for Database
	dbName := terraform.Output(t, terraformOptions, "db_name")
	db := azure.GetSqlDatabase(t, dbName, resourceGroupName, subscriptionID)
	assert.NotNil(t, db)
}
