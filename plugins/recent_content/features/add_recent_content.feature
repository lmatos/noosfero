Feature:
  In order to add a recent content block
  As a logged user
  I want to add recent content block

Background:
  Given the following users
    | login      |  name      |  
    | joaosilva  | Joao Silva |
  And the following plugin
    | klass          |
    | RecentContent |
  And plugin RecentContent is enabled on environment
  And the following blocks 
    | owner     |         type       |
    | joaosilva | RecentContentBlock |
  Given the following blogs
    | owner     | name        |
    | joaosilva | JSilva blog |
  And the following articles
    | owner     | parent      | name    |  body | abstract |
    | joaosilva | JSilva blog | post #1 | Primeiro post do joao silva | Resumo 1 |
    | joaosilva | JSilva blog | post #2 | Segundo post do joao silva | Resumo 2 |
    | joaosilva | JSilva blog | post #4 | Terceiro post do joao silva | Resumo 3 |
  And I am logged in as "joaosilva"
    Given I go to joaosilva's control panel
    And I follow "Edit sideboxes"
    And I follow "Add a block"
    And I choose "Recent content"
    And I press "Add"
  
  Scenario: a user can add a Recent Content Block
    Then I should see "This is the recent content block"
  
  Scenario: a user can view Recent Content from de published blog post using title only display option11
    When I follow "Edit" within ".recent-content-block"
    And I select "JSilva blog" from "Choose which content should be displayed:"
    And I select "Title only" from "Choose how the content should be displayed:"
    And I fill in "Choose how many items will be displayed:" with "5"
    And I press "Save"
    Then I should see "post #1" within ".recent-content-block"

  Scenario: a user can view the last published blog post in the Recent Content
    When I follow "Edit" within ".recent-content-block"
    And I select "JSilva blog" from "Choose which content should be displayed:"
    And I select "Title only" from "Choose how the content should be displayed:"
    And I fill in "Choose how many items will be displayed:" with "1"
    And I press "Save"
    Then I should see "post #4" within ".recent-content-block"
  
  #this test only works using selenium because the div ".title" is generated dinamically
  @selenium
  Scenario: a user should see the full post from a blog post when the blog post is selected
    When I follow "Edit" within ".recent-content-block"
    And I select "JSilva blog" from "Choose which content should be displayed:"
    And I select "Title only" from "Choose how the content should be displayed:"
    And I fill in "Choose how many items will be displayed:" with "3"
    And I press "Save"
    And I follow "post #2" within ".recent-content-block"
    Then I should see "post #2" within ".title"

  @selenium
  Scenario: a user should see all the posts from a blog when following the view all option
    When I follow "Edit" within ".recent-content-block"
    And I select "JSilva blog" from "Choose which content should be displayed:"
    And I select "Title only" from "Choose how the content should be displayed:"
    And I fill in "Choose how many items will be displayed:" with "2"
    And I press "Save"
    And I follow "View All" 
    Then I should see "post #4" within ".odd-post"

  @selenium
  Scenario: a user can view Recent Content from de published blog post using full content display option
    When I follow "Edit" within ".recent-content-block"
    And I select "JSilva blog" from "Choose which content should be displayed:"
    And I select "Full content" from "Choose how the content should be displayed:"
    And I fill in "Choose how many items will be displayed:" with "3"
    And I press "Save"
    Then I should see "Terceiro post do joao silva" within ".recent-content-block"


  @selenium
  Scenario: a user can view Recent Content from de published blog post using title and abstract content display option
    When I follow "Edit" within ".recent-content-block"
    And I select "JSilva blog" from "Choose which content should be displayed:"
    And I select "Title and abstract" from "Choose how the content should be displayed:"
    And I fill in "Choose how many items will be displayed:" with "1"
    And I press "Save"
    Then I should see "Resumo 3" within ".headline"


