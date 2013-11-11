class LinkTreeBlock < Block
  
  settings_items :links, :type => Array, :default => []
  
  ICONS = [
    ['no-icon', _('(No icon)')],
    ['edit', N_('Edit')],
    ['new', N_('New')],
    ['save', N_('Save')],
    ['send', N_('Send')],
    ['cancel', N_('Cancel')],
    ['add', N_('Add')],
    ['up', N_('Up')],
    ['down', N_('Down')],
    ['left', N_('Left')],
    ['right', N_('Right')],
    ['up-disabled', N_('Gray Up')],
    ['down-disabled', N_('Gray Down')],
    ['left-disabled', N_('Gray Left')],
    ['right-disabled', N_('Gray Right')],
    ['up-red', N_('Red Up')],
    ['search', N_('Search')],
    ['ok', N_('Ok')],
    ['login', N_('Login')],
    ['help', N_('Help')],
    ['spread', N_('Spread')],
    ['eyes', N_('Eyes')],
    ['photos', N_('Photos')],
    ['menu-people', N_('Person')],
    ['event', N_('Event')],
    ['forum', N_('Forum')],
    ['home', N_('Home')],
    ['product', N_('Package')],
    ['todo', N_('To do list')],
    ['chat', N_('Chat')]
  ]
    
  def self.description
    _('Link tree')
  end

  def help
    _('This block can be used to create tree like menu of links.')
  end
      
  def icons_options
    ICONS.map do |i|
      "<span title=\"#{i[1]}\" class=\"icon-#{i[0]}\" onclick=\"changeIcon(this, '#{i[0]}')\"></span>".html_safe
    end
  end
  
  def content_for_edit
    "<h1>EDICAO MANO </h1>"
  end
  
  def content(args={})
  
    if links.empty?
      _('Please edit this block and add some links.')
    else
      "There are #{links.size} links"
#      tree = "<ul>"
#      links.each do |link|
#        tree += link_content(link)
#      end
#      tree += "</ul>"
    end
  end
  
#  private 
  
  
#  def link_content(link)
#   
#    if link.has_children?
#      tree = "<ul>" + content_tag('a',link.sanitize)
#      link.children.each do |child|
#        tree += link_content(child)
#      end
#      tree += "</ul>"
#    else
#      content_tag('li', content_tag('a', link.sanitize))
#    end
#  end
  
end
