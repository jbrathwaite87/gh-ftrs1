Feature: Ensure Resource Groups are correctly configured

  Scenario: Ensure Resource Group has tags
    Given I have resource_group defined
    Then it must contain tags
    And its value must not be null

  Scenario: Ensure Resource Group is in allowed locations
    Given I have resource_group defined
    Then it must contain location
    And its value must be in ["eastus", "westus"]
