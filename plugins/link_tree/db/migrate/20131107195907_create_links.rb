class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :link_tree_plugin_links do |t|
      t.text    :title
      t.text    :icon
      t.text    :url
      t.belongs_to :link_tree_plugin_link
    end
  end

  def self.down
    drop_table :link_tree_plugin_links
  end
end
