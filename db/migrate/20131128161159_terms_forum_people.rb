class TermsForumPeople < ActiveRecord::Migration
  def self.up
  	create_table :terms_forum_people, :id => false do |t|
		t.integer :forum_id
		t.integer :person_id
	end
  end

  def self.down
  	drop_table :terms_forum_people
  end
end
