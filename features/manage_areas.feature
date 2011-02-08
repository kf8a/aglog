Feature: Manage observations
  In order to [goal]
  [stakeholder]
  wants [behaviour]
  
  Scenario: Index and show as non-logged-in-user
    Given an area exists with a name of "cool_area"
      And I am on the areas page
    Then I should see "cool_area"
      And I should not see "Edit"
      And I should not see "Destroy"
    
    When I follow "Show" within "tr#cool_area"
      Then I should see "Name: cool_area"

  Scenario: Index and show and edit as logged-in-user
    Given an area exists with a name of "cool_area"
      And I am signed in
      And I am on the areas page
    Then I should see "cool_area"
      And I should see "Edit"
      And I should see "Destroy"
    
    When I follow "Show" within "tr#cool_area"
    Then I should see "Name: cool_area"
      And I should see "Edit"
    
    When I follow "Edit"
    Then I should see "Editing area"
