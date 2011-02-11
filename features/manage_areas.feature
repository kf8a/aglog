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

  Scenario: Index and show and edit and update as logged-in-user
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

    When I fill in "Name" with "cooler_area"
      And I press "Update Area"
    Then I should see "Name: cooler_area"

  Scenario: New area created and deleted as a logged-in-user
    Given I am signed in
      And I am on the areas page
      And I follow "New area"
    Then I should see "New area"

    When I fill in "Name" with "brand_new_area"
      And I select "MAIN" from "Study"
      And I press "Create Area"
    Then I should see "Name: brand_new_area"
      And I should see "Area was successfully created."
    
    When I follow "Back"
      Then I should see "brand_new_area"

    When I follow "Destroy" within "tr#brand_new_area"
      Then I should not see "brand_new_area"


