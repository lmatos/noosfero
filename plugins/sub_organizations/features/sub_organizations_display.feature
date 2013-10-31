Feature: sub_organizations_display
  
  As a user
  I want my organizations to have blocks that lists it's related-organizations
  In order to have quick access to it's related-organizations


   Background:
   Given "SubOrganizations" plugin is enabled
    And the following users
      | login | name |
      | nelson | Nelson |
    
   And the following community
      | identifier | name | owner |
      | springfield | Springfield | nelson |
   And I am logged in as "nelson"
   And I go to springfield's control panel
   
   @selenium
   Scenario:Don't display the sub organization block
      When I follow "Edit sideboxes"
      And I follow "Add a block"
      And I choose "Related Organizations"
      And I press "Add"
      Then I should not see ".related-organizations-block" 

