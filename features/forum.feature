Feature: forum
  As a noosfero user
  I want to have one or mutiple forums

  Background:
    Given I am on the homepage
    And the following users
      | login     | name       |
      | joaosilva | Joao Silva |
      | mariasilva| Maria Silva|
    And "joaosilva" has no articles
    And I am logged in as "joaosilva"

  @selenium @ignore-hidden-elements
  Scenario: create a forum
    Given I am on joaosilva's control panel
    And I follow "Manage Content"
    And I follow "New content"
    When I follow "Forum"
    And I fill in "Title" with "My Forum"
    And I press "Save"
    Then I should see "Configure forum"

  Scenario: redirect to forum after create forum from cms
    Given I go to joaosilva's control panel
    And I follow "Manage Content"
    And I follow "New content"
    When I follow "Forum"
    And I fill in "Title" with "Forum from cms"
    And I press "Save"
    Then I should be on /joaosilva/forum-from-cms

  Scenario: create multiple forums
    Given I go to joaosilva's control panel
    And I follow "Manage Content"
    And I follow "New content"
    And I follow "Forum"
    And I fill in "Title" with "Forum One"
    And I press "Save"
    Then I go to joaosilva's control panel
    And I follow "Manage Content"
    And I follow "New content"
    And I follow "Forum"
    And I fill in "Title" with "Forum Two"
    And I press "Save"
    Then I should not see "error"
    And I should be on /joaosilva/forum-two

  Scenario: cancel button back to cms
    Given I go to joaosilva's control panel
    And I follow "Manage Content"
    And I follow "New content"
    And I follow "Forum"
    When I follow "Cancel" within ".main-block"
    Then I should be on /myprofile/joaosilva/cms

  Scenario: cancel button back to myprofile
    Given I go to joaosilva's control panel
    And I follow "Manage Content"
    And I follow "New content"
    And I follow "Forum"
    When I follow "Cancel" within ".main-block"
    Then I should be on /myprofile/joaosilva/cms

  @selenium
  Scenario: configure forum when viewing it
    Given the following forums
       | owner     | name      |
       | joaosilva | Forum One |
    And I go to /joaosilva/forum-one
    When I follow "Configure forum"
    Then I should be on edit "Forum One" by joaosilva

  Scenario: last topic update by unautenticated user should not link
    Given the following forums
       | owner     | name |
       | joaosilva | Forum |
    And the following articles
       | owner     | name | parent |
       | joaosilva | Post one | Forum |
    And the following comments
       | article | name | email | title | body |
       | Post one | Joao | joao@example.com | Hi all | Hi all |
   When I go to /joaosilva/forum
   Then I should not see "Joao" link

  Scenario: last topic update by autenticated user should link to profile url
    Given the following forums
       | owner     | name |
       | joaosilva | Forum |
    And the following articles
       | owner     | name | parent |
       | joaosilva | Post one | Forum |
    And the following comments
       | article | author | title | body |
       | Post one | joaosilva | Hi all | Hi all |
   When I go to /joaosilva/forum
   Then I should see "Joao" linking to "http://localhost/joaosilva"

  @selenium
  Scenario: the newest post from a forum should be displayed first.
      Given the following forums
       | owner     | name |
       | joaosilva | Forum |
    And the following articles
       | owner     | name | parent |
       | joaosilva | Post one | Forum |
    And the following comments
       | article | author | title | body |
       | Post one | joaosilva | Hi all | Hi all |
       | Post one | joaosilva | Hello  | Hello  | 
   When I go to /joaosilva/forum/post-one
   And I select "Newest first" from "comment_mode" within ".comment-order"
   Then I should see "Hello" within ".article-comment"

  @selenium
  Scenario: the oldest post from a forum should be displayed first.
      Given the following forums
       | owner     | name |
       | joaosilva | Forum |
    And the following articles
       | owner     | name | parent |
       | joaosilva | Post one | Forum |
    And the following comments
       | article | author | title | body |
       | Post one | joaosilva | Hi all | Hi all |
       | Post one | joaosilva | Hello  | Hello  | 
   When I go to /joaosilva/forum/post-one
   And I select "Oldest first" from "comment_mode" within ".comment-order"
   Then I should see "Hi all" within ".article-comment"
