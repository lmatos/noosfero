class LinkTreePlugin::Link < Noosfero::Plugin::ActiveRecord

  has_many :children, :class_name => 'LinkTreePlugin::Link', :foreign_key => 'link_tree_plugin_link_id'
  belongs_to :parent, :class_name => 'LinkTreePlugin::Link'

end
