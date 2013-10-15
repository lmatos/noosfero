require File.dirname(__FILE__) + '/../test_helper'

class MembersBlockTest < ActiveSupport::TestCase

  should 'inherit from ProfileListBlock' do
    assert_kind_of ProfileListBlock, MembersBlock.new
  end

  should 'describe itself' do
    assert_not_equal ProfileListBlock.description, MembersBlock.description
  end

  should 'provide a default title' do
    assert_not_equal ProfileListBlock.new.default_title, MembersBlock.new.default_title
  end

  should 'link to "all members" page' do
    profile = create_user('mytestuser').person
    block = MembersBlock.new
    block.box = profile.boxes.first
    block.save!

    expects(:_).with('View all').returns('View all')
    expects(:link_to).with('View all' , :profile => 'mytestuser', :controller => 'profile', :action => 'members').returns('link-to-members')

    assert_equal 'link-to-members', instance_eval(&block.footer)[0]
  end

  should 'pick random members' do
    block = MembersBlock.new

    owner = mock
    block.expects(:owner).returns(owner)

    list = []
    owner.expects(:members).returns(list)
    
    assert_same list, block.profiles
  end

  should "options return br, checkbox, label and hidden" do
    block = MembersBlock.new

    assert_equal "<br />", block.options[0]
    assert block.options[1].include? "input type='checkbox'"
    assert block.options[2].include? "label for"
    assert block.options[3].include? "input type='hidden'"
  end

  should "check_join_leave_button? return checked if show_join_leave_button is true" do
    block = MembersBlock.new
    block.show_join_leave_button = true
    
    assert_equal "checked='checked'", block.send(:check_join_leave_button?)
  end

  should "check_join_leave_button? does not return checked if show_join_leave_button is false" do
    block = MembersBlock.new
    block.show_join_leave_button = false
    
    assert_equal "", block.send(:check_join_leave_button?)
  end

  should "save_join_leave_button? return 1 if show_join_leave_button is false" do
    block = MembersBlock.new
    block.show_join_leave_button = false
    
    assert_equal "1", block.send(:save_join_leave_button?)
  end

  should "save_join_leave_button? return 0 if show_join_leave_button is true" do
    block = MembersBlock.new
    block.show_join_leave_button = true
    
    assert_equal "0", block.send(:save_join_leave_button?)
  end

  should "footer has only 'View all' if show_join_leave_button is false" do
    env = fast_create(Environment)
    profile = create_user('mytestuser').person
    block = MembersBlock.new
    block.box = profile.boxes.first
    block.save!
  
    block.stubs(:show_join_leave_button).returns(false)
    
    expects(:_).with('View all').returns('View all')
    expects(:link_to).with('View all' , :profile => 'mytestuser', :controller => 'profile', :action => 'members').returns('link-to-members')
    
    link = instance_eval(&block.footer)
    assert_equal "link-to-members", link[0]
    assert_equal 1, link.size
  end
  
end
