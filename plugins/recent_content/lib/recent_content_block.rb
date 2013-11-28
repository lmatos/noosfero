class RecentContentBlock < Block

  settings_items :presentation_mode, :type => String, :default => 'title_only'
  settings_items :total_items, :type => Integer, :default => 5
  settings_items :show_blog_picture, :type => :boolean, :default => false
  settings_items :selected_folder, :type => Integer

  VALID_CONTENT = ['RawHTMLArticle', 'TextArticle', 'TextileArticle', 'TinyMceArticle']
  
  def self.description
    _('Recent content')
  end

  def help
    _('This block displays all articles inside the blog you choose. You can edit the block to select which of your blogs is going to be displayed in the block.')
  end

  def articles_of_folder(folder, limit)
   holder.articles.all(:conditions => {:type => VALID_CONTENT, :parent_id => folder.id},
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
    selected = self.holder.articles.all(:conditions => {:type => 'Blog'})
  end
  
  def root
    unless self.selected_folder.nil?
      Blog.find(self.selected_folder)
    end
  end

  include ActionController::UrlWriter
  include DatesHelper

  def content(args={})
    block = self
    lambda do
      render :file => 'blocks/recent_content_block', :locals => {:root => block.root, :block => block}
    end
  end

  def mode?(attr)
    attr == self.presentation_mode 
  end

end
