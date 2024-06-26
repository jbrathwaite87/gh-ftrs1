Feature: Ensure Virtual Machines are correctly configured

  Scenario: Ensure Virtual Machine has size defined
    Given I have azure_virtual_machine defined
    Then it must contain size
    And its value must not be null

  Scenario: Ensure Virtual Machine is in allowed locations
    Given I have azure_virtual_machine defined
    Then it must contain location
    And its value must be in ["eastus", "westus"]
