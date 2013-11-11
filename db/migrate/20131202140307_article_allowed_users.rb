class ArticleAllowedUsers < ActiveRecord::Migration
  def self.up
    create_table :article_allowed_users, :id => false do |t|
      t.integer :article_id
      t.integer :person_id
    end
  end

  def self.down
    drop_table :article_allowed_users
  end
end
