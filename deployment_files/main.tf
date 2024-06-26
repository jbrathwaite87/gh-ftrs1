provider "azurerm" {
  features {} 
}

data "azurerm_resource_group" "name" {
  name = var.resource_group_name
}
