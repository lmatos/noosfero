class AddSettingsToProfile < ActiveRecord::Migration
  def self.up
		add_column :profiles, :settings, :text
  end

  def self.down
    remove_column :profiles, :settings
  end
end
