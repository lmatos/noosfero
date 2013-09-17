class VideoBlock < Block

  settings_items :url, :type => :string, :default => ""

  def self.description
    _('Add Video')
  end

  def help
    _('This block presents a video block.')
  end

  def content(args={})
    block = self

    lambda do
      render :file => 'blocks/video_block', :locals => { :block => block }
    end
  end

  def cacheable?
    false
  end
  
end
