class VideoBlock < Block

  settings_items :url, :type => :string, :default => ""
  settings_items :width, :type => :integer, :default => 400
  settings_items :height, :type => :integer, :default => 315
  
  def is_youtube? 
    false

    if url.include?("youtube.com")
      true
    end
  end

  def is_vimeo? 
    false

    if url.include?("vimeo.com")
      true
    end
  end

  def is_file? 
    false

    extensions = [".mp4", ".ogg", ".ogv", ".wmv"]
    if extensions.include? url[-4, 4]
      true
    end
  end

  def format_embed_video_url_for_youtube
    self.url.gsub("watch?v=", "embed/")
  end

  def format_embed_video_url_for_vimeo
    self.url.gsub("vimeo.com/", "player.vimeo.com/video/")
  end

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
