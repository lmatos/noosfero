Feature: 
  In order to add a video block
  As a logged user
  I want to add video block

  Background:
    Given the following users
      | login     | name       |
      | joaosilva | Joao Silva |
    And the following plugin
      | klass |
      | Video |
    And plugin Video is enabled on environment
    And the following blocks
      | owner | type |
      | joaosilva | VideoBlock |
    And I am logged in as "joaosilva"

  Scenario: a user can add a Video block
    Given I go to joaosilva's control panel
    And I follow "Edit sideboxes"
    When I follow "Add a block"
    Then I should see "Add Video"

  Scenario: a user can add and edit a Video block
    Given I go to joaosilva's control panel
    When I follow "Edit sideboxes"
    And I follow "Edit" within ".video-block"
    And I fill in "block_title" with "Free Software"
    And I fill in "block_url" with "http://www.youtube.com/watch?v=x_pxT9rJiaU"
    And I press "Save"
    Then I should see "Free Software"