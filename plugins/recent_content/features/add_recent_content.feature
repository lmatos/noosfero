Feature:
	In order to add a recent content block
	As a logged user
	I want to add recent content block

Background:
	Given the following users
		| login  		 |  name      |  
		| joaosilva  | Joao Silva |
	And the following plugin
		| klass          |
		| RecentContent |
	And plugin RecentContent is enabled on environment
	And the following blocks 
		| owner     |  				type			 |
		| joaosilva | RecentContentBlock |
  And I am logged in as "joaosilva"
	@selenium
	Scenario: a user can add a Recent Content Block
		Given I go to joaosilva's control panel
		And I follow "Edit sideboxes"
		When I follow "Add a block"
		And I choose "Recent content"
	  And I press "Add"
	  Then I should see "This is the recent content block" 