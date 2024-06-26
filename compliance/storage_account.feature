Feature: Ensure Storage Accounts are correctly configured

  Scenario: Ensure Storage Account has secure transfer enabled
    Given I have azure_storage_account defined
    Then it must contain enable_https_traffic_only
    And its value must be true

  Scenario: Ensure Storage Account is of allowed types
    Given I have azure_storage_account defined
    Then it must contain account_kind
    And its value must be in ["StorageV2"]
