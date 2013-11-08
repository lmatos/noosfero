require_dependency File.dirname(__FILE__) + '/link_tree_block'

class LinkTreePlugin < Noosfero::Plugin

  def self.plugin_name
    _("Link tree")
  end
  
  def self.plugin_description
    _("Provide an usefull link tree block, similar to the link list block, with the possibility to create sub links")
  end
  
  def self.extra_blocks
    {
      LinkTreeBlock => {}
    }
  end
  
  def stylesheet?
    false
  end
end
