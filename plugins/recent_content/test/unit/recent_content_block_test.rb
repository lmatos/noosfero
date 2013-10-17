require File.dirname(__FILE__) + '/../test_helper'
class RecentContentBlockTest < ActiveSupport::TestCase

  INVALID_KIND_OF_ARTICLE = [EnterpriseHomepage, RssFeed, UploadedFile, Gallery, Folder, Blog, Forum]
  VALID_KIND_OF_ARTICLE = [RawHTMLArticle, TextArticle, TextileArticle, TinyMceArticle]

  should 'describe itself' do
    assert_not_equal Block.description, RecentContentBlock.description
  end

  should 'is editable' do
    block = RecentContentBlock.new
    assert block.editable?
  end

  should 'blog_picture be false by default' do
    block = RecentContentBlock.new
    assert !block.blog_picture
  end

  should 'blog_picture is being stored and restored from database as true' do
    block = RecentContentBlock.new
    block.blog_picture = true
    block.save
    block.reload

    assert block.blog_picture
  end

  should 'blog_picture is being stored and restored from database as false' do
    block = RecentContentBlock.new
    block.blog_picture = false
    block.save
    block.reload

    assert !block.blog_picture
  end

end
