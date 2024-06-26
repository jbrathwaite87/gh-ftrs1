Feature: Ensure Virtual Networks are correctly configured

  Scenario: Ensure Virtual Network has address space defined
    Given I have azure_virtual_network defined
    Then it must contain address_space
    And its value must not be null

  Scenario: Ensure Virtual Network is in allowed locations
    Given I have azure_virtual_network defined
    Then it must contain location
    And its value must be in ["eastus", "westus"]
