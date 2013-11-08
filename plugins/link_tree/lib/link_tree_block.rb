class LinkTreeBlock < Block
  
  settings_items :links, :type => Array, :default => []
  
  def self.description
    _('Link tree')
  end

  def help
    _('This block can be used to create tree like menu of links.')
  end
  
  def content(args={})
    tree = "<ul>"
    links.each do |link|
      tree += link_content(link)
    end
    tree += "</ul>"
  end
  
  private 
  
  def link_content(link)
   
    if link.has_children?
      tree = "<ul>" + content_tag('a',link.sanitize)
      link.children.each do |child|
        tree += link_content(child)
      end
      tree += "</ul>"
    else
      content_tag('li', content_tag('a', link.sanitize))
    end
  end
  
end
