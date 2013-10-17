require_dependency File.dirname(__FILE__) + '/recent_content_block'

class RecentContentPlugin < Noosfero::Plugin

  def self.plugin_name
    "Recent Content Plugin"
  end

  def self.plugin_description
    _("A plugin that adds a block where you could choose any of your folders and display the content on it.")
  end

  def self.extra_blocks
    {
      RecentContentBlock => {:position => ['1','2','3'] }
    }
  end

  def self.has_admin_url?
    false
  end
  
  def stylesheet?
    true
  end

end