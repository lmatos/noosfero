class Forum < Folder

  acts_as_having_posts :order => 'updated_at DESC'
  include PostsLimit

  settings_items :terms_of_use, :type => :string, :default => ""
  settings_items :has_terms_of_use, :type => :boolean, :default => false
  settings_items :users_with_agreement, :type => Array, :default => []

  def self.type_name
    _('Forum')
  end

  def self.short_description
    _('Forum')
  end

  def self.description
    _('An internet forum, also called message board, where discussions can be held.')
  end

  include ActionView::Helpers::TagHelper
  def to_html(options = {})
    lambda do
      render :file => 'content_viewer/forum_page'
    end
  end

  def forum?
    true
  end

  def self.icon_name(article = nil)
    'forum'
  end

  def notifiable?
    true
  end

  def first_paragraph
    return '' if body.blank?
    paragraphs = Hpricot(body).search('p')
    paragraphs.empty? ? '' : paragraphs.first.to_html
  end
end
