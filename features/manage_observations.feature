Feature: Manage observations
  In order to [goal]
  [stakeholder]
  wants [behaviour]
  
  Scenario: Related observations
    Given an observation exists
      And I am on the observations page
    When I follow "Show"
      Then I should see "Related Observations"
    When I follow "Related Observations"
      Then I should be on the related observations page