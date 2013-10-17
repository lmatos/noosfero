class RecentContentBlock < Block

  settings_items :presentation_mode, :type => String, :default => 'title_only'
  settings_items :total_itens, :type => Integer, :default => 5
  settings_items :show_blog_picture, :type => :boolean, :default => false
  settings_items :selected_folder, :type => Integer

  VALID_CONTENT = ['RawHTMLArticle', 'TextArticle', 'TextileArticle', 'TinyMceArticle']
  
  def self.description
    _('Recent content')
  end

  def help
    _('This block displays all articles inside the folder you choose. You can edit the block to select which of your folders is going to be displayed in the block.')
  end
  

  def articles_of_folder(folder, limit)
    Article.all(:conditions => {:type => VALID_CONTENT, :parent_id => folder.id},
                :order => 'created_at DESC',
                :limit => limit )
  end
  
  def holder
    return nil if self.box.nil? || self.box.owner.nil?
    if self.box.owner.kind_of?(Environment) 
      return nil if self.box.owner.portal_community.nil?
      self.box.owner.portal_community
    else
      self.box.owner
    end
  end
  
  def parents
    selected = []
    self.holder.articles.find_all.map do |article|
      if article.blog?
        selected << article
      end
    end
    selected
  end

  include ActionController::UrlWriter
  
  def content(args={})
    
    
    if !self.selected_folder.nil?
      root = Blog.find(self.selected_folder)
      text = block_title((title.nil? or title.empty?) ? _("Recent content") : title) +
             (self.show_blog_picture and  !root.image.nil? ?
              content_tag('div',image_tag(root.image.public_filename(:big), :alt=>title),:class=>"recent-content-cover") :
             '')
      children = articles_of_folder(root,self.total_itens) 
      
      if mode?('title_only')
        text + render_title_only(children)
      elsif mode?('title_and_abstract')
        text + render_title_and_abstract(children)
      else
        text + render_full_content(children)
      end      
    end
  end

  def footer
    return nil unless self.owner.is_a?(Profile)

    profile = self.owner
    lambda do
      link_to _('View All'), :profile => profile.identifier, :controller => 'content_viewer', :action => 'view_page', :page => 'blog'
    end
  end

  def mode?(attr)
    attr == self.presentation_mode 
  end
  
  
  protected
  
  def render_title_only(itens)
    content_tag('div',
      content_tag('ul', itens.map {|item|  
        content_tag('li', content_tag('div', link_to(h(item.title), item.url), :class => 'title'))
      }.join("\n")), :class => 'recent-content-title')
  end
  
  include DatesHelper
  
  def render_title_and_abstract(itens)
    content_tag("div", itens.map {|item|
      content_tag("h2",link_to(item.title, item.url, :class => 'post-title') ) +
      content_tag("span",show_date(item.published_at, true),:class=>'post-date') +
      content_tag("div",item.lead, :class => 'headline') +
      content_tag("p",link_to(_('Read more'), item.url), :class =>'highlighted-news-read-more')
    }.join("\n"),:class => 'recent-content-abstract')
  end
  
  def render_full_content(itens)
    content_tag("div", itens.map {|item|
      content_tag("h2",link_to(item.title, item.url, :class => 'post-title') ) +
      content_tag("span",show_date(item.published_at, true),:class=>'post-date') +
      content_tag("div",item.body, :class => 'headline') +
      content_tag("p",link_to(_('Read more'), item.url), :class =>'highlighted-news-read-more')
    }.join("\n"), :class => 'recent-content-full')
  end

end
