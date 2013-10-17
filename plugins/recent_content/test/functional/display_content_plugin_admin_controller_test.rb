require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../controllers/display_content_plugin_admin_controller'


# Re-raise errors caught by the controller.
class DisplayContentPluginAdminControllerController; def rescue_action(e) raise e end; end

class DisplayContentPluginAdminControllerTest < ActionController::TestCase

  def setup
    @controller = DisplayContentPluginAdminController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @environment = Environment.default
    user_login = create_admin_user(@environment)
    login_as(user_login)
    @admin = User[user_login].person
    @environment.enabled_plugins = ['DisplayContentPlugin']
    @environment.portal_community = fast_create(Community, :name => 'my test profile', :identifier => 'mytestcommunity')
    @environment.save!
  
    box = Box.new(:owner => @environment, :position => 1)
    box.save

    DisplayContentBlock.delete_all
    @block = DisplayContentBlock.new
    @block.box = environment.boxes.first
    @block.save!
  end

  attr_accessor :environment, :block

  should 'access index action' do
    get :index, :block_id => block.id
    json_response = ActiveSupport::JSON.decode(@response.body)
    assert_response :success
  end

  should 'index action returns a empty json if there is no content' do
    Article.delete_all
    get :index, :block_id => block.id
    json_response = ActiveSupport::JSON.decode(@response.body)
    assert_equivalent [], json_response
  end

  should 'index action returns an json with node content' do
    Article.delete_all
    article = fast_create(TextileArticle, :name => 'test article 1', :profile_id => environment.portal_community.id)

    get :index, :block_id => block.id
    json_response = ActiveSupport::JSON.decode(@response.body)
    expected_json = {'data' => article.title}
    expected_json['attr'] = { 'node_id' => article.id, 'parent_id' => article.parent_id}

    assert_equivalent [expected_json], json_response
  end

  should 'index action returns an json with node checked if the node is in the nodes list' do
    Article.delete_all
    article = fast_create(TextileArticle, :name => 'test article 1', :profile_id => environment.portal_community.id)
    block.nodes= [article.id]
    block.save!

    get :index, :block_id => block.id
    json_response = ActiveSupport::JSON.decode(@response.body)
    expected_json = {'data' => article.title}
    expected_json['attr'] = { 'node_id' => article.id, 'parent_id' => article.parent_id}
    expected_json['attr'].merge!({'class' => 'jstree-checked'})

    assert_equivalent [expected_json], json_response
  end

  should 'index action returns an json with node undetermined if the node is in the parent nodes list' do
    Article.delete_all
    article = fast_create(TextileArticle, :name => 'test article 1', :profile_id => environment.portal_community.id)
    block.parent_nodes= [article.id]
    block.save!

    get :index, :block_id => block.id
    json_response = ActiveSupport::JSON.decode(@response.body)
    expected_json = {'data' => article.title}
    expected_json['attr'] = { 'node_id' => article.id, 'parent_id' => article.parent_id}
    expected_json['attr'].merge!({'class' => 'jstree-undetermined'})
    expected_json['children'] = []

    assert_equivalent [expected_json], json_response
  end

  should 'index action returns an json with node closed if the node has article with children' do
    Article.delete_all
    f = fast_create(Folder, :name => 'test folder 1', :profile_id => environment.portal_community.id)
    article = fast_create(TextileArticle, :name => 'test article 1', :profile_id => environment.portal_community.id, :parent_id => f.id)

    get :index, :block_id => block.id
    json_response = ActiveSupport::JSON.decode(@response.body)
    expected_json = {'data' => f.title}
    expected_json['attr'] = { 'node_id' => f.id, 'parent_id' => f.parent_id}
    expected_json['state'] = 'closed'

    assert_equivalent [expected_json], json_response
  end

  should 'index action returns an json with all the children nodes if some parent is in the parents list' do
    Article.delete_all
    f = fast_create(Folder, :name => 'test folder 1', :profile_id => environment.portal_community.id)
    a1 = fast_create(TextileArticle, :name => 'test article 1', :profile_id => environment.portal_community.id, :parent_id => f.id)
    a2 = fast_create(TextileArticle, :name => 'test article 2', :profile_id => environment.portal_community.id, :parent_id => f.id)
    block.parent_nodes = [f.id]
    block.save!

    get :index, :block_id => block.id
    json_response = ActiveSupport::JSON.decode(@response.body)
    expected_json = {'data' => f.title}
    expected_json['attr'] = { 'node_id' => f.id, 'parent_id' => f.parent_id}
    children = [
      {'data' => a1.title, 'attr' => {'node_id' => a1.id, 'parent_id' => a1.parent_id}},
      {'data' => a2.title, 'attr' => {'node_id' => a2.id, 'parent_id'=> a2.parent_id}}
    ]
    expected_json['attr'].merge!({'class' => 'jstree-undetermined'})
    expected_json['children'] = children
    expected_json['state'] = 'closed'

    assert_equivalent [expected_json], json_response
  end

  should 'index action returns an json with all the children nodes and root nodes if some parent is in the parents list and there is others root articles' do
    Article.delete_all
    f = fast_create(Folder, :name => 'test folder 1', :profile_id => environment.portal_community.id)
    a1 = fast_create(TextileArticle, :name => 'test article 1', :profile_id => environment.portal_community.id, :parent_id => f.id)
    a2 = fast_create(TextileArticle, :name => 'test article 2', :profile_id => environment.portal_community.id, :parent_id => f.id)
    a3 = fast_create(TextileArticle, :name => 'test article 3', :profile_id => environment.portal_community.id)
    block.parent_nodes = [f.id]
    block.save!

    get :index, :block_id => block.id
    json_response = ActiveSupport::JSON.decode(@response.body)
    expected_json = []
    value = {'data' => f.title}
    value['attr'] = { 'node_id' => f.id, 'parent_id' => f.parent_id}
    children = [
     {'data' => a1.title, 'attr' => {'node_id' => a1.id, 'parent_id' => a1.parent_id}},
     {'data' => a2.title, 'attr' => {'node_id' => a2.id, 'parent_id'=> a2.parent_id}}
    ]
    value['attr'].merge!({'class' => 'jstree-undetermined'})
    value['children'] = children
    value['state'] = 'closed'
    expected_json.push(value)

    value = {'data' => a3.title}
    value['attr'] = { 'node_id' => a3.id, 'parent_id' => a3.parent_id}
    expected_json.push(value)

    assert_equivalent expected_json, json_response
  end

  should 'index action returns an json without children nodes if the parent is not in the parents list' do
    Article.delete_all
    f = fast_create(Folder, :name => 'test folder 1', :profile_id => environment.portal_community.id)
    a1 = fast_create(TextileArticle, :name => 'test article 1', :profile_id => environment.portal_community.id, :parent_id => f.id)
    a2 = fast_create(TextileArticle, :name => 'test article 2', :profile_id => environment.portal_community.id, :parent_id => f.id)
    a3 = fast_create(TextileArticle, :name => 'test article 3', :profile_id => environment.portal_community.id)

    get :index, :block_id => block.id
    json_response = ActiveSupport::JSON.decode(@response.body)
    expected_json = []
    value = {'data' => f.title}
    value['attr'] = { 'node_id' => f.id, 'parent_id' => f.parent_id}
    value['state'] = 'closed'
    expected_json.push(value)

    value = {'data' => a3.title}
    value['attr'] = { 'node_id' => a3.id, 'parent_id' => a3.parent_id}
    expected_json.push(value)

    assert_equivalent expected_json, json_response
  end

end
