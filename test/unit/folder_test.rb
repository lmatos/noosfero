require File.dirname(__FILE__) + '/../test_helper'

class FolderTest < ActiveSupport::TestCase

  should 'be an article' do
    assert_kind_of Article, Folder.new
  end

  should 'provide proper description' do
    assert_kind_of String, Folder.description
  end

  should 'provide proper short description' do
    assert_kind_of String, Folder.short_description
  end

  should 'provide own icon name' do
    assert_not_equal Article.icon_name, Folder.icon_name
  end

  should 'identify as folder' do
    assert Folder.new.folder?, 'folder must identity itself as folder'
  end

  should 'can display hits' do
    profile = create_user('testuser').person
    a = fast_create(Folder, :profile_id => profile.id)
    assert_equal false, a.can_display_hits?
  end

  should 'have images that are only images or other folders' do
    p = create_user('test_user').person
    f = fast_create(Folder, :profile_id => p.id)
    file = UploadedFile.create!(:uploaded_data => fixture_file_upload('/files/test.txt', 'text/plain'), :parent => f, :profile => p)
    image = UploadedFile.create!(:uploaded_data => fixture_file_upload('/files/rails.png', 'image/png'), :parent => f, :profile => p)
    folder = fast_create(Folder, :profile_id => p.id, :parent_id => f.id)

    assert_equivalent [folder, image], f.images
  end

  should 'bring folders first in alpha order in images listing' do
    p = create_user('test_user').person
    f = fast_create(Folder, :profile_id => p.id)
    folder1 = fast_create(Folder, :name => 'b', :profile_id => p.id, :parent_id => f.id)
    image = UploadedFile.create!(:uploaded_data => fixture_file_upload('/files/rails.png', 'image/png'), :parent => f, :profile => p)
    folder2 = fast_create(Folder, :name => 'c', :profile_id => p.id, :parent_id => f.id)
    folder3 = fast_create(Folder, :name => 'a', :profile_id => p.id, :parent_id => f.id)

    assert_equal [folder3.id, folder1.id, folder2.id, image.id], f.images.map(&:id)
  end

  should 'images support pagination' do
    p = create_user('test_user').person
    f = fast_create(Folder, :profile_id => p.id)
    folder = fast_create(Folder, :profile_id => p.id, :parent_id => f.id)
    image = UploadedFile.create!(:uploaded_data => fixture_file_upload('/files/rails.png', 'image/png'), :parent => f, :profile => p)

    assert_equal [image], f.images.paginate(:page => 2, :per_page => 1)
  end

  should 'return newest text articles as news' do
    c = fast_create(Community)
    folder = fast_create(Folder, :profile_id => c.id)
    f = fast_create(Folder, :name => 'folder', :profile_id => c.id, :parent_id => folder.id)
    u = UploadedFile.create!(:profile => c, :uploaded_data => fixture_file_upload('/files/rails.png', 'image/png'), :parent => folder)
    older_t = fast_create(TinyMceArticle, :name => 'old news', :profile_id => c.id, :parent_id => folder.id)
    t = fast_create(TinyMceArticle, :name => 'news', :profile_id => c.id, :parent_id => folder.id)
    t_in_f = fast_create(TinyMceArticle, :name => 'news', :profile_id => c.id, :parent_id => f.id)

    assert_equal [t], folder.news(1)
  end

  should 'not return highlighted news when not asked' do
    c = fast_create(Community)
    folder = fast_create(Folder, :profile_id => c.id)
    highlighted_t = fast_create(TinyMceArticle, :name => 'high news', :profile_id => c.id, :highlighted => true, :parent_id => folder.id)
    t = fast_create(TinyMceArticle, :name => 'news', :profile_id => c.id, :parent_id => folder.id)

    assert_equal [t].map(&:slug), folder.news(2).map(&:slug)
  end

  should 'return highlighted news when asked' do
    c = fast_create(Community)
    folder = fast_create(Folder, :profile_id => c.id)
    highlighted_t = fast_create(TinyMceArticle, :name => 'high news', :profile_id => c.id, :highlighted => true, :parent_id => folder.id)
    t = fast_create(TinyMceArticle, :name => 'news', :profile_id => c.id, :parent_id => folder.id)

    assert_equal [highlighted_t].map(&:slug), folder.news(2, true).map(&:slug)
  end

  should 'return published images as images' do
    person = create_user('test_user').person
    image = UploadedFile.create!(:profile => person, :uploaded_data => fixture_file_upload('/files/rails.png', 'image/png'))

    community = fast_create(Community)
    folder = fast_create(Folder, :profile_id => community.id)
    a = ApproveArticle.create!(:article => image, :target => community, :requestor => person, :article_parent => folder)
    a.finish

    assert_includes folder.images(true), community.articles.find_by_name('rails.png')
  end

  should 'not let pass javascript in the body' do
    folder = Folder.new
    folder.body = "<script> alert(Xss!); </script>"
    folder.valid?

    assert_no_match /(<script>)/, folder.body
  end

  should 'filter fields with white_list filter' do
    folder = Folder.new
    folder.body = "<h1> Body </h1>"
    folder.valid?

    assert_equal "<h1> Body </h1>", folder.body
  end

  should 'not sanitize html comments' do
    folder = Folder.new
    folder.body = '<p><!-- <asdf> << aasdfa >>> --> <h1> Wellformed html code </h1>'
    folder.valid?

    assert_match  /<!-- .* --> <h1> Wellformed html code <\/h1>/, folder.body
  end

  should 'escape malformed html tags' do
    folder = Folder.new
    folder.body = "<h1<< Description >>/h1>"
    folder.valid?

    assert_no_match /[<>]/, folder.body
  end

  should 'not have a blog as parent' do
    folder = Folder.new
    folder.parent = Blog.new
    folder.valid?

    assert folder.errors.on(:parent)
  end

  should 'accept uploads' do
    folder = fast_create(Folder)
    assert folder.accept_uploads?
  end
  
    
  should 'has a empty list of allowed_users by default' do
    a = Folder.new
    assert_equal [], a.allowed_users
  end
  
  should 'has a public value for visibility by default' do
    a = Folder.new
    assert_equal 'public', a.visibility
  end
  
  should 'user see private folder when is included in allowed_user list' do
    community = fast_create(Community)
    member = create_user.person

    community.add_member(member)
    a = Folder.new(:profile => community, :visibility => 'private', :allowed_users => member.id )
    
    assert a.display_to?(member)
  
  end
  
   should 'not see private folder when is not included in allowed_user list' do
    community = fast_create(Community)
    memberAllow = create_user.person
    memberUnallow = create_user.person

    community.add_member(memberAllow)
    community.add_member(memberUnallow)
    a = Folder.new(:profile => community, :visibility => 'private', :allowed_users => memberAllow.id )
    
    assert !a.display_unpublished_article_to?(memberUnallow) && a.display_to?(memberAllow)
  
  end
  
   should 'say that logged off user cannot see private folder' do
    profile = fast_create(Profile, :name => 'test profile', :identifier => 'test_profile')
    folder  = Folder.new(:name => 'test folder', :profile_id => profile.id, :visibility => 'private')

    assert folder.display_unpublished_article_to?(nil)
  end
  
   should 'not allow friends of private person see the folder' do
    person = create_user('test_user').person
    folder = Folder.create!(:name => 'test folder', :profile => person, :visibility => 'private')
    friend = create_user('test_friend').person
    person.add_friend(friend)
    person.save!
    friend.save!

    assert !folder.display_unpublished_article_to?(friend)
  end
  
  should 'say that member user can not see private folder' do
    profile = fast_create(Profile, :name => 'test profile', :identifier => 'test_profile')
    folder = Folder.create!(:name => 'test folder', :profile_id => profile.id, :visibility => 'private')
    person = create_user('test_user').person
    profile.affiliate(person, Profile::Roles.member(profile.environment.id))

    assert !folder.display_to?(person)
  end
  
  should 'say that not member of profile can not see private folder' do
    profile = fast_create(Profile, :name => 'test profile', :identifier => 'test_profile')
    folder = Folder.create!(:name => 'test folder', :profile_id => profile.id, :visibility => 'private')
    person = create_user('test_user').person

    assert !folder.display_unpublished_article_to?(person)
  end  

end
