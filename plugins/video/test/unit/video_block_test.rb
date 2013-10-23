require File.dirname(__FILE__) + '/../test_helper'
class VideoBlockTest < ActiveSupport::TestCase

  ### Tests for YouTube

  should "is_youtube return true when the url contains http://youtube.com" do
    block = VideoBlock.new
    block.url = "http://youtube.com/?v=XXXXX"
    assert block.is_youtube?
  end
  
  should "is_youtube return true when the url contains https://youtube.com" do
    block = VideoBlock.new
    block.url = "https://youtube.com/?v=XXXXX"
    assert block.is_youtube?
  end
  
  should "is_youtube return true when the url contains https://www.youtube.com" do
    block = VideoBlock.new
    block.url = "https://www.youtube.com/?v=XXXXX"
    assert block.is_youtube?
  end
  
  should "is_youtube return true when the url contains www.youtube.com" do
    block = VideoBlock.new
    block.url = "www.youtube.com/?v=XXXXX"
    assert block.is_youtube?
  end

  should "is_youtube return true when the url contains youtube.com" do
    block = VideoBlock.new
    block.url = "youtube.com/?v=XXXXX"
    assert block.is_youtube?
  end

  should "is_youtube return false when the url not contains youtube.com video ID" do
    block = VideoBlock.new
    block.url = "youtube.com/"
    assert_equal(false, block.is_youtube?)
  end

  should "is_youtube return false when the url contains an empty youtube.com video ID" do
    block = VideoBlock.new
    block.url = "youtube.com/?v="
    assert_equal(false, block.is_youtube?)
  end

  should "is_youtube return false when the url contains empty youtu.be video ID" do
    block = VideoBlock.new
    block.url = "youtu.be/"
    assert_equal(false, block.is_youtube?)
  end

  should "is_youtube return false when the url contains an invalid youtube link" do
    block = VideoBlock.new
    block.url = "http://www.yt.com/?v=XXXXX"
    assert !block.is_youtube?
  end
   
  #### Tests for Vimeo Videos
  
  should "is_vimeo return true when the url contains http://vimeo.com" do
    block = VideoBlock.new
    block.url = "http://vimeo.com/98979"
    assert block.is_vimeo?
  end
  
  should "is_vimeo return true when the url contains https://vimeo.com" do
    block = VideoBlock.new
    block.url = "https://vimeo.com/989798"
    assert block.is_vimeo?
  end
  
  should "is_vimeo return true when the url contains https://www.vimeo.com" do
    block = VideoBlock.new
    block.url = "https://www.vimeo.com/98987"
    assert block.is_vimeo?
  end
  
  should "is_vimeo return true when the url contains www.vimeo.com" do
    block = VideoBlock.new
    block.url = "www.vimeo.com/989798"
    assert block.is_vimeo?
  end

  should "is_vimeo return true when the url contains vimeo.com" do
    block = VideoBlock.new
    block.url = "vimeo.com/09898"
    assert block.is_vimeo?
  end

  should "is_vimeo return false when the url contains an invalid vimeo.com ID" do
    block = VideoBlock.new
    block.url = "vimeo.com/a09898"
    assert_equal(false, block.is_vimeo?)
  end

  should "is_vimeo return false when the url contains an empty vimeo.com ID" do
    block = VideoBlock.new
    block.url = "vimeo.com/"
    assert_equal(false, block.is_vimeo?)
  end

  should "is_vimeo return true when the url contains http://player.vimeo.com/video" do
    block = VideoBlock.new
    block.url = "http://player.vimeo.com/video/12345"
    assert block.is_vimeo?
  end

  should "is_vimeo return true when the url contains https://player.vimeo.com/video" do
    block = VideoBlock.new
    block.url = "https://player.vimeo.com/video/12345"
    assert block.is_vimeo?
  end

  should "is_vimeo return false when the url contains an empty player.vime ID" do
    block = VideoBlock.new
    block.url = "http://player.vimeo.com/video/"
    assert_equal(false, block.is_vimeo?)
  end

  should "is_vimeo return false when the url contains an invalid player.vime ID" do
    block = VideoBlock.new
    block.url = "http://player.vimeo.com/video/a123b"
    assert_equal(false, block.is_vimeo?)
  end

  should "is_vimeo return false when the url not contains vimeo video ID" do
    block = VideoBlock.new
    block.url = "vimeo.com/home"
    assert_equal(false, block.is_vimeo?)
  end

  should "is_vimeo return false when the url contains an invalid vimeo link" do
    block = VideoBlock.new
    block.url = "http://www.vmsd.com/98979"
    assert !block.is_vimeo?
  end

  # Other video formats
  should "is_video return true if url ends with mp4" do
    block = VideoBlock.new
    block.url = "http://www.vmsd.com/98979.mp4"
    assert block.is_video_file?
  end

  should "is_video return true if url ends with ogg" do
    block = VideoBlock.new
    block.url = "http://www.vmsd.com/98979.ogg"
    assert block.is_video_file?
  end

  should "is_video return true if url ends with ogv" do
    block = VideoBlock.new
    block.url = "http://www.vmsd.com/98979.ogv"
    assert block.is_video_file?
  end

  should "is_video return true if url ends with webm" do
    block = VideoBlock.new
    block.url = "http://www.vmsd.com/98979.webm"
    assert block.is_video_file?
  end

  should "is_video return false if url ends without mp4, ogg, ogv, webm" do
    block = VideoBlock.new
    block.url = "http://www.vmsd.com/98979.mp4r"
    assert !block.is_video_file?
    block.url = "http://www.vmsd.com/98979.oggr"
    assert !block.is_video_file?
    block.url = "http://www.vmsd.com/98979.ogvr"
    assert !block.is_video_file?
    block.url = "http://www.vmsd.com/98979.webmr"
    assert !block.is_video_file?
  end

  # Tests for VideoBlock.extract_youtube_id

  should "extract_youtube_id return the ID from any valid youtube url" do
    block = VideoBlock.new

    block.url = "youtube.com/?v=1a2b3c"
    assert_equal("1a2b3c", block.send(:extract_youtube_id))

    block.url = "www.youtube.com/?v=1a2b3c"
    assert_equal("1a2b3c", block.send(:extract_youtube_id))

    block.url = "http://youtube.com/?v=1a2b3c"
    assert_equal("1a2b3c", block.send(:extract_youtube_id))

    block.url = "http://www.youtube.com/?v=1a2b3c"
    assert_equal("1a2b3c", block.send(:extract_youtube_id))

    block.url = "https://youtube.com/?v=1a2b3c"
    assert_equal("1a2b3c", block.send(:extract_youtube_id))

    block.url = "https://www.youtube.com/?v=1a2b3c"
    assert_equal("1a2b3c", block.send(:extract_youtube_id))

    block.url = "youtu.be/1a2b3c"
    assert_equal("1a2b3c", block.send(:extract_youtube_id))

    block.url = "www.youtu.be/1a2b3c"
    assert_equal("1a2b3c", block.send(:extract_youtube_id))

    block.url = "http://youtu.be/1a2b3c"
    assert_equal("1a2b3c", block.send(:extract_youtube_id))

    block.url = "https://youtu.be/1a2b3c"
    assert_equal("1a2b3c", block.send(:extract_youtube_id))

    block.url = "http://www.youtu.be/1a2b3c"
    assert_equal("1a2b3c", block.send(:extract_youtube_id))
    
    block.url = "https://www.youtu.be/1a2b3c"
    assert_equal("1a2b3c", block.send(:extract_youtube_id))
  end

  # Tests for VideoBlock.extract_vimeo_id

  should "extract_vimeo_id return the ID from any valid vimeo url" do
    block = VideoBlock.new

    block.url = "vimeo.com/12345"
    assert_equal("12345", block.send(:extract_vimeo_id))

    block.url = "www.vimeo.com/12345"
    assert_equal("12345", block.send(:extract_vimeo_id))

    block.url = "http://vimeo.com/12345"
    assert_equal("12345", block.send(:extract_vimeo_id))

    block.url = "http://www.vimeo.com/12345"
    assert_equal("12345", block.send(:extract_vimeo_id))

    block.url = "https://vimeo.com/12345"
    assert_equal("12345", block.send(:extract_vimeo_id))

    block.url = "https://www.vimeo.com/12345"
    assert_equal("12345", block.send(:extract_vimeo_id))

    block.url = "http://player.vimeo.com/video/12345"
    assert_equal("12345", block.send(:extract_vimeo_id))

    block.url = "https://player.vimeo.com/video/12345"
    assert_equal("12345", block.send(:extract_vimeo_id))
  end

  # Tests for format_embed_video_url_for_youtube
  should "format_embed_video_url_for_youtube return an ambed url from any valid youtube url" do
    block = VideoBlock.new

    block.url = "youtube.com/?v=1a2b3c"
    assert_equal("//www.youtube-nocookie.com/embed/1a2b3c?rel=0&wmode=transparent", block.format_embed_video_url_for_youtube)

    block.url = "www.youtube.com/?v=1a2b3c"
    assert_equal("//www.youtube-nocookie.com/embed/1a2b3c?rel=0&wmode=transparent", block.format_embed_video_url_for_youtube)

    block.url = "http://youtube.com/?v=1a2b3c"
    assert_equal("//www.youtube-nocookie.com/embed/1a2b3c?rel=0&wmode=transparent", block.format_embed_video_url_for_youtube)

    block.url = "http://www.youtube.com/?v=1a2b3c"
    assert_equal("//www.youtube-nocookie.com/embed/1a2b3c?rel=0&wmode=transparent", block.format_embed_video_url_for_youtube)

    block.url = "https://youtube.com/?v=1a2b3c"
    assert_equal("//www.youtube-nocookie.com/embed/1a2b3c?rel=0&wmode=transparent", block.format_embed_video_url_for_youtube)

    block.url = "https://www.youtube.com/?v=1a2b3c"
    assert_equal("//www.youtube-nocookie.com/embed/1a2b3c?rel=0&wmode=transparent", block.format_embed_video_url_for_youtube)

    block.url = "youtu.be/1a2b3c"
    assert_equal("//www.youtube-nocookie.com/embed/1a2b3c?rel=0&wmode=transparent", block.format_embed_video_url_for_youtube)

    block.url = "www.youtu.be/1a2b3c"
    assert_equal("//www.youtube-nocookie.com/embed/1a2b3c?rel=0&wmode=transparent", block.format_embed_video_url_for_youtube)

    block.url = "http://youtu.be/1a2b3c"
    assert_equal("//www.youtube-nocookie.com/embed/1a2b3c?rel=0&wmode=transparent", block.format_embed_video_url_for_youtube)

    block.url = "https://youtu.be/1a2b3c"
    assert_equal("//www.youtube-nocookie.com/embed/1a2b3c?rel=0&wmode=transparent", block.format_embed_video_url_for_youtube)

    block.url = "http://www.youtu.be/1a2b3c"
    assert_equal("//www.youtube-nocookie.com/embed/1a2b3c?rel=0&wmode=transparent", block.format_embed_video_url_for_youtube)
    
    block.url = "https://www.youtu.be/1a2b3c"
    assert_equal("//www.youtube-nocookie.com/embed/1a2b3c?rel=0&wmode=transparent", block.format_embed_video_url_for_youtube)
  end

  # Tests for format_embed_video_url_for_vimeo
  should "format_embed_video_url_for_vimeo return an ambed url from any valid vimeo url" do
    block = VideoBlock.new

    block.url = "vimeo.com/12345"
    assert_equal("//player.vimeo.com/video/12345", block.format_embed_video_url_for_vimeo)

    block.url = "www.vimeo.com/12345"
    assert_equal("//player.vimeo.com/video/12345", block.format_embed_video_url_for_vimeo)

    block.url = "http://vimeo.com/12345"
    assert_equal("//player.vimeo.com/video/12345", block.format_embed_video_url_for_vimeo)

    block.url = "http://www.vimeo.com/12345"
    assert_equal("//player.vimeo.com/video/12345", block.format_embed_video_url_for_vimeo)

    block.url = "https://vimeo.com/12345"
    assert_equal("//player.vimeo.com/video/12345", block.format_embed_video_url_for_vimeo)

    block.url = "https://www.vimeo.com/12345"
    assert_equal("//player.vimeo.com/video/12345", block.format_embed_video_url_for_vimeo)

    block.url = "http://player.vimeo.com/video/12345"
    assert_equal("//player.vimeo.com/video/12345", block.format_embed_video_url_for_vimeo)

    block.url = "https://player.vimeo.com/video/12345"
    assert_equal("//player.vimeo.com/video/12345", block.format_embed_video_url_for_vimeo)
  end

  # Test fo help
  should "help return the VideoBlock help text" do
    block = VideoBlock.new
    assert_equal(_('This block presents a video block.'), block.help)
  end
end
