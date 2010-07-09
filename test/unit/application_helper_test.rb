require File.dirname(__FILE__) + '/../test_helper'

class ApplicationHelperTest < Test::Unit::TestCase

  include ApplicationHelper

  def setup
    self.stubs(:session).returns({})
  end

  should 'retrieve conf from "web2.0" config file' do
    yml = RAILS_ROOT + '/config/web2.0.yml'
    conf = {
      'addthis'=>{'pub'=>'mylogin', 'options'=>'favorites, email'},
      'gravatar'=>{'default'=>'wavatar'}
    }
    File.expects(:exists?).with(yml).returns(true)
    YAML.expects(:load_file).with(yml).returns(conf)
    assert_equal conf, web2_conf
  end

  should 'calculate correctly partial for object' do
    self.stubs(:params).returns({:controller => 'test'})

    File.expects(:exists?).with("#{RAILS_ROOT}/app/views/test/_float.rhtml").returns(false)
    File.expects(:exists?).with("#{RAILS_ROOT}/app/views/test/_numeric.rhtml").returns(true).times(2)
    File.expects(:exists?).with("#{RAILS_ROOT}/app/views/test/_runtime_error.rhtml").returns(true).at_least_once

    assert_equal 'numeric', partial_for_class(Float)
    assert_equal 'numeric', partial_for_class(Numeric)
    assert_equal 'runtime_error', partial_for_class(RuntimeError)
  end

  should 'give error when there is no partial for class' do
    assert_raises ArgumentError do
      partial_for_class(nil)
    end
  end

  should 'generate link to stylesheet' do
    File.expects(:exists?).with(File.join(RAILS_ROOT, 'public', 'stylesheets', 'something.css')).returns(true)
    expects(:filename_for_stylesheet).with('something', nil).returns('/stylesheets/something.css')
    assert_match '@import url(/stylesheets/something.css)', stylesheet_import('something')
  end

  should 'not generate link to unexisting stylesheet' do
    File.expects(:exists?).with(File.join(RAILS_ROOT, 'public', 'stylesheets', 'something.css')).returns(false)
    expects(:filename_for_stylesheet).with('something', nil).returns('/stylesheets/something.css')
    assert_no_match %r{@import url(/stylesheets/something.css)}, stylesheet_import('something')
  end

  should 'handle nil dates' do
    assert_equal '', show_date(nil)
  end


  should 'append with-text class and keep existing classes' do
    expects(:button_without_text).with('type', 'label', 'url', { :class => 'with-text class1'})
    button('type', 'label', 'url', { :class => 'class1' })
  end

  should 'generate correct link to category' do
    cat = mock
    cat.expects(:path).returns('my-category/my-subcatagory')
    cat.expects(:full_name).returns('category name')
    cat.expects(:environment).returns(Environment.default)
    Environment.any_instance.expects(:default_hostname).returns('example.com')

    result = "/cat/my-category/my-subcatagory"
    expects(:link_to).with('category name', :controller => 'search', :action => 'category_index', :category_path => ['my-category', 'my-subcatagory'], :host => 'example.com').returns(result)
    assert_same result, link_to_category(cat)
  end

  should 'nil theme option when no exists theme' do
    stubs(:current_theme).returns('something-very-unlikely')
    File.expects(:exists?).returns(false)
    assert_nil theme_option()
  end

  should 'nil javascript theme when no exists theme' do
    stubs(:current_theme).returns('something-very-unlikely')
    File.expects(:exists?).returns(false)
    assert_nil theme_javascript
  end

  should 'role color for admin role' do
    assert_equal 'blue', role_color(Profile::Roles.admin(Environment.default.id), Environment.default.id)
  end
  should 'role color for member role' do
    assert_equal 'green', role_color(Profile::Roles.member(Environment.default.id), Environment.default.id)
  end
  should 'role color for moderator role' do
    assert_equal 'gray', role_color(Profile::Roles.moderator(Environment.default.id), Environment.default.id)
  end
  should 'default role color' do
    assert_equal 'black', role_color('none', Environment.default.id)
  end

  should 'rolename for' do
    person = create_user('usertest').person
    community = fast_create(Community, :name => 'new community', :identifier => 'new-community', :environment_id => Environment.default.id)
    community.add_member(person)
    assert_equal 'Profile Member', rolename_for(person, community)
  end

  should 'get theme from environment by default' do
    @environment = mock
    @environment.stubs(:theme).returns('my-environment-theme')
    stubs(:profile).returns(nil)
    assert_equal 'my-environment-theme', current_theme
  end

  should 'get theme from profile when profile is present' do
    profile = mock
    profile.stubs(:theme).returns('my-profile-theme')
    stubs(:profile).returns(profile)
    assert_equal 'my-profile-theme', current_theme
  end

  should 'override theme with testing theme from session' do
    stubs(:session).returns(:theme => 'theme-under-test')
    assert_equal 'theme-under-test', current_theme
  end

  should 'point to system theme path by default' do
    expects(:current_theme).returns('my-system-theme')
    assert_equal '/designs/themes/my-system-theme', theme_path
  end

  should 'point to user theme path when testing theme' do
    stubs(:session).returns({:theme => 'theme-under-test'})
    assert_equal '/user_themes/theme-under-test', theme_path
  end

  should 'render theme footer' do
    stubs(:theme_path).returns('/user_themes/mytheme')
    footer_path = RAILS_ROOT + '/public/user_themes/mytheme/footer.rhtml'

    File.expects(:exists?).with(footer_path).returns(true)
    expects(:render).with(:file => footer_path, :use_full_path => false).returns("BLI")

    assert_equal "BLI", theme_footer
  end

  should 'ignore unexisting theme footer' do
    stubs(:theme_path).returns('/user_themes/mytheme')
    footer_path = RAILS_ROOT + '/public/user_themes/mytheme/footer.rhtml'
    alternate_footer_path = RAILS_ROOT + '/public/user_themes/mytheme/footer.html.erb'

    File.expects(:exists?).with(footer_path).returns(false)
    File.expects(:exists?).with(alternate_footer_path).returns(false)
    expects(:render).with(:file => footer).never

    assert_nil theme_footer
  end

  should 'expose theme owner' do
    theme = mock
    profile = mock
    Theme.expects(:find).with('theme-under-test').returns(theme)
    theme.expects(:owner).returns(profile)
    profile.expects(:identifier).returns('sampleuser')

    stubs(:current_theme).returns('theme-under-test')

    assert_equal 'sampleuser', theme_owner
  end

  should 'use default template when there is no profile' do
    stubs(:profile).returns(nil)
    assert_equal "/designs/templates/default/stylesheets/style.css", template_stylesheet_path
  end

  should 'use template from profile' do
    profile = mock
    profile.expects(:layout_template).returns('mytemplate')
    stubs(:profile).returns(profile)

    assert_equal '/designs/templates/mytemplate/stylesheets/style.css', template_stylesheet_path
  end

  should 'use https:// for login_url' do
    environment = Environment.default
    environment.update_attribute(:enable_ssl, true)
    environment.domains << Domain.new(:name => "test.domain.net", :is_default => true)
    stubs(:environment).returns(environment)

    stubs(:url_for).with(has_entries(:protocol => 'https://', :host => 'test.domain.net')).returns('LALALA')

    assert_equal 'LALALA', login_url
  end

  should 'not force ssl in login_url when environment has ssl disabled' do
    environment = mock
    environment.expects(:enable_ssl).returns(false).at_least_once
    stubs(:environment).returns(environment)
    request = mock
    request.stubs(:host).returns('localhost')
    stubs(:request).returns(request)

    expects(:url_for).with(has_entries(:protocol => 'https://')).never
    expects(:url_for).with(has_key(:controller)).returns("LALALA")
    assert_equal "LALALA", login_url
  end

  should 'return nil if disable_categories is enabled' do
    env = fast_create(Environment, :name => 'env test')
    stubs(:environment).returns(env)
    assert_not_nil env
    env.enable(:disable_categories)
    assert env.enabled?(:disable_categories)
    assert_nil select_categories(mock)
  end

  should 'provide sex icon for males' do
    stubs(:environment).returns(Environment.default)
    expects(:content_tag).with(anything, 'male').returns('MALE!!')
    expects(:content_tag).with(anything, 'MALE!!', is_a(Hash)).returns("FINAL")
    assert_equal "FINAL", profile_sex_icon(Person.new(:sex => 'male'))
  end

  should 'provide sex icon for females' do
    stubs(:environment).returns(Environment.default)
    expects(:content_tag).with(anything, 'female').returns('FEMALE!!')
    expects(:content_tag).with(anything, 'FEMALE!!', is_a(Hash)).returns("FINAL")
    assert_equal "FINAL", profile_sex_icon(Person.new(:sex => 'female'))
  end

  should 'provide undef sex icon' do
    stubs(:environment).returns(Environment.default)
    expects(:content_tag).with(anything, 'undef').returns('UNDEF!!')
    expects(:content_tag).with(anything, 'UNDEF!!', is_a(Hash)).returns("FINAL")
    assert_equal "FINAL", profile_sex_icon(Person.new(:sex => nil))
  end

  should 'not draw sex icon for non-person profiles' do
    assert_equal '', profile_sex_icon(Community.new)
  end

  should 'not draw sex icon when disabled in the environment' do
    env = fast_create(Environment, :name => 'env test')
    env.expects(:enabled?).with('disable_gender_icon').returns(true)
    stubs(:environment).returns(env)
    assert_equal '', profile_sex_icon(Person.new(:sex => 'male'))
  end

  should 'display field on person signup' do
    env = Environment.create!(:name => 'env test')
    stubs(:environment).returns(env)

    controller = mock
    stubs(:controller).returns(controller)
    controller.expects(:action_name).returns('signup')

    person = Person.new
    person.expects(:signup_fields).returns(['field'])
    assert_equal 'SIGNUP_FIELD', optional_field(person, 'field', 'SIGNUP_FIELD')
  end

  should 'display field on enterprise registration' do
    env = Environment.create!(:name => 'env test')
    stubs(:environment).returns(env)

    controller = mock
    stubs(:controller).returns(controller)
    controller.stubs(:controller_name).returns('enterprise_registration')
    controller.stubs(:action_name).returns('index')

    enterprise = Enterprise.new
    enterprise.expects(:signup_fields).returns(['field'])
    assert_equal 'SIGNUP_FIELD', optional_field(enterprise, 'field', 'SIGNUP_FIELD')
  end

  should 'display field on community creation' do
    env = Environment.create!(:name => 'env test')
    stubs(:environment).returns(env)

    controller = mock
    stubs(:controller).returns(controller)
    controller.stubs(:action_name).returns('new_community')

    community = Community.new
    community.expects(:signup_fields).returns(['field'])
    assert_equal 'SIGNUP_FIELD', optional_field(community, 'field', 'SIGNUP_FIELD')
  end

  should 'not display field on signup' do
    env = fast_create(Environment, :name => 'env test')
    stubs(:environment).returns(env)

    controller = mock
    stubs(:controller).returns(controller)
    controller.expects(:action_name).returns('signup')

    person = Person.new
    person.expects(:signup_fields).returns([])
    assert_equal '', optional_field(person, 'field', 'SIGNUP_FIELD')
  end

  should 'not display field on enterprise registration' do
    env = Environment.create!(:name => 'env test')
    stubs(:environment).returns(env)

    controller = mock
    stubs(:controller).returns(controller)
    controller.stubs(:controller_name).returns('enterprise_registration')
    controller.stubs(:action_name).returns('index')

    enterprise = Enterprise.new
    enterprise.expects(:signup_fields).returns([])
    assert_equal '', optional_field(enterprise, 'field', 'SIGNUP_FIELD')
  end

  should 'not display field on community creation' do
    env = Environment.create!(:name => 'env test')
    stubs(:environment).returns(env)

    controller = mock
    stubs(:controller).returns(controller)
    controller.stubs(:action_name).returns('new_community')

    community = Community.new
    community.stubs(:signup_fields).returns([])
    assert_equal '', optional_field(community, 'field', 'SIGNUP_FIELD')
  end

  should 'display active fields' do
    env = fast_create(Environment, :name => 'env test')
    stubs(:environment).returns(env)

    controller = mock
    stubs(:controller).returns(controller)
    controller.stubs(:controller_name).returns('')
    controller.stubs(:action_name).returns('edit')

    profile = Person.new
    profile.expects(:active_fields).returns(['field'])
    assert_equal 'SIGNUP_FIELD', optional_field(profile, 'field', 'SIGNUP_FIELD')
  end

  should 'not display active fields' do
    env = fast_create(Environment, :name => 'env test')
    stubs(:environment).returns(env)

    controller = mock
    stubs(:controller).returns(controller)
    controller.stubs(:action_name).returns('edit')
    controller.stubs(:controller_name).returns('')

    profile = Person.new
    profile.expects(:active_fields).returns([])
    assert_equal '', optional_field(profile, 'field', 'SIGNUP_FIELD')
  end

  should 'display required fields' do
    env = fast_create(Environment, :name => 'env test')
    stubs(:environment).returns(env)

    controller = mock
    stubs(:controller).returns(controller)
    controller.stubs(:controller_name).returns('')
    controller.stubs(:action_name).returns('edit')

    stubs(:required).with('SIGNUP_FIELD').returns('<span>SIGNUP_FIELD</span>')
    profile = Person.new
    profile.expects(:active_fields).returns(['field'])
    profile.expects(:required_fields).returns(['field'])
    assert_equal '<span>SIGNUP_FIELD</span>', optional_field(profile, 'field', 'SIGNUP_FIELD')
  end

  should 'not ask_to_join unless profile defined' do
    stubs(:params).returns({})

    e = Environment.default
    e.stubs(:enabled?).with(:join_community_popup).returns(true)
    stubs(:environment).returns(e)

    stubs(:profile).returns(nil)
    assert ! ask_to_join?
  end

  should 'not ask_to_join unless profile is community' do
    stubs(:params).returns({})
    e = Environment.default
    e.stubs(:enabled?).with(:join_community_popup).returns(true)
    stubs(:environment).returns(e)

    p = create_user('test_user').person
    stubs(:profile).returns(p)
    assert ! ask_to_join?
  end

  should 'not ask_to_join if action join' do
    expects(:params).returns({:action => 'join'})

    e = Environment.default
    e.stubs(:enabled?).with(:join_community_popup).returns(true)
    stubs(:environment).returns(e)

    c = fast_create(Community, :name => 'test_comm', :identifier => 'test_comm')
    stubs(:profile).returns(c)
    stubs(:logged_in?).returns(false)
    assert ! ask_to_join?
  end

  should 'ask_to_join if its not logged and in a community' do
    stubs(:params).returns({})

    e = Environment.default
    e.stubs(:enabled?).with(:join_community_popup).returns(true)
    stubs(:environment).returns(e)

    c = fast_create(Community, :name => 'test_comm', :identifier => 'test_comm')
    stubs(:profile).returns(c)
    stubs(:logged_in?).returns(false)
    assert ask_to_join?
  end

  should 'ask_to_join if user say so' do
    stubs(:params).returns({})

    e = Environment.default
    e.stubs(:enabled?).with(:join_community_popup).returns(true)
    stubs(:environment).returns(e)

    c = fast_create(Community, :name => 'test_comm', :identifier => 'test_comm')
    stubs(:profile).returns(c)
    stubs(:logged_in?).returns(true)
    p = create_user('test_user').person
    p.stubs(:ask_to_join?).with(c).returns(true)
    stubs(:user).returns(p)

    assert ask_to_join?
  end

  should 'not ask_to_join if user say no' do
    stubs(:params).returns({})

    e = Environment.default
    e.stubs(:enabled?).with(:join_community_popup).returns(true)
    stubs(:environment).returns(e)
    c = fast_create(Community, :name => 'test_comm', :identifier => 'test_comm')
    stubs(:profile).returns(c)
    stubs(:logged_in?).returns(true)
    p = create_user('test_user').person
    p.stubs(:ask_to_join?).with(c).returns(false)
    stubs(:user).returns(p)

    assert !ask_to_join?
  end

  should 'not ask_to_join if environment say no even if its not logged and in a community' do
    stubs(:params).returns({})

    e = Environment.default
    e.stubs(:enabled?).with(:join_community_popup).returns(false)
    stubs(:environment).returns(e)
    c = fast_create(Community, :name => 'test_comm', :identifier => 'test_comm')
    stubs(:profile).returns(c)
    stubs(:logged_in?).returns(false)
    assert !ask_to_join?
  end

  should 'not ask_to_join if environment say no even if user say so' do
    stubs(:params).returns({})

    e = Environment.default
    e.stubs(:enabled?).with(:join_community_popup).returns(false)
    stubs(:environment).returns(e)
    c = fast_create(Community, :name => 'test_comm', :identifier => 'test_comm')
    stubs(:profile).returns(c)
    stubs(:logged_in?).returns(true)
    p = create_user('test_user').person
    p.stubs(:ask_to_join?).with(c).returns(true)
    stubs(:user).returns(p)

    assert !ask_to_join?
  end

  should 'not ask_to_join if its recorded in the session' do
    stubs(:params).returns({})

    e = Environment.default
    e.stubs(:enabled?).with(:join_community_popup).returns(true)
    stubs(:environment).returns(e)

    c = fast_create(Community, :name => 'test_comm', :identifier => 'test_comm')
    stubs(:profile).returns(c)
    stubs(:logged_in?).returns(false)
    stubs(:session).returns({:no_asking => [c.id]})

    assert !ask_to_join?
  end

  should 'not ask_to_join if its recorded in the session even for authenticated users' do
    stubs(:params).returns({})

    e = Environment.default
    e.stubs(:enabled?).with(:join_community_popup).returns(true)
    stubs(:environment).returns(e)

    c = fast_create(Community, :name => 'test_comm', :identifier => 'test_comm')
    stubs(:profile).returns(c)
    stubs(:logged_in?).returns(true)
    stubs(:session).returns({:no_asking => [c.id]})

    assert !ask_to_join?
  end

  should 'use default icon theme when there is no stylesheet file for the current icon theme' do
    e = Environment.default
    e.icon_theme = 'something-very-unlikely'
    stubs(:environment).returns(e)
    assert_equal "/designs/icons/default/style.css", icon_theme_stylesheet_path
  end

  should 'not display active field if only required' do
    profile = mock
    profile.expects(:required_fields).returns([])

    assert_equal '', optional_field(profile, :field_name, '<html tags>', true)
  end

  should 'display name on page title if profile doesnt have nickname' do
    stubs(:environment).returns(Environment.default)

    c = fast_create(Community, :name => 'Comm name', :identifier => 'test_comm')
    stubs(:profile).returns(c)
    assert_match(/Comm name/, page_title)
  end

  should 'display nickname on page title if profile has nickname' do
    stubs(:environment).returns(Environment.default)

    c = fast_create(Community, :name => 'Community for tests', :nickname => 'Community nickname', :identifier => 'test_comm')
    stubs(:profile).returns(c)
    assert_match(/Community nickname/, page_title)
  end

  should 'generate a gravatar url' do
    stubs(:web2_conf).returns({"gravatar" => {"default" => "wavatar"}})
    url = str_gravatar_url_for( 'rms@gnu.org', :size => 50 )
    assert_match(/^http:\/\/www\.gravatar\.com\/avatar\.php\?/, url)
    assert_match(/(\?|&)gravatar_id=ed5214d4b49154ba0dc397a28ee90eb7(&|$)/, url)
    assert_match(/(\?|&)d=wavatar(&|$)/, url)
    assert_match(/(\?|&)size=50(&|$)/, url)
  end

  should 'use theme passed via param when in development mode' do
    stubs(:environment).returns(Environment.new(:theme => 'environment-theme'))
    ENV.stubs(:[]).with('RAILS_ENV').returns('development')
    self.stubs(:params).returns({:theme => 'my-theme'})
    assert_equal 'my-theme', current_theme
  end

  should 'not use theme passed via param when in production mode' do
    stubs(:environment).returns(Environment.new(:theme => 'environment-theme'))
    ENV.stubs(:[]).with('RAILS_ENV').returns('production')
    self.stubs(:params).returns({:theme => 'my-theme'})
    stubs(:profile).returns(Profile.new(:theme => 'profile-theme'))
    assert_equal 'profile-theme', current_theme
  end

  should 'use environment theme if the profile theme is nil' do
    stubs(:environment).returns(fast_create(Environment, :theme => 'new-theme'))
    stubs(:profile).returns(fast_create(Profile))
    assert_equal environment.theme, current_theme
  end

  should 'trunc to 15 chars the big filename' do
    assert_equal 'AGENDA(...).mp3', short_filename('AGENDA_CULTURA_-_FESTA_DE_VAQUEIROS_PONTO_DE_SERRA_PRETA_BAIXA.mp3',15)
  end

  should 'trunc to default limit the big filename' do
    assert_equal 'AGENDA_CULTURA_-_FESTA_DE_VAQUEIRO(...).mp3', short_filename('AGENDA_CULTURA_-_FESTA_DE_VAQUEIROS_PONTO_DE_SERRA_PRETA_BAIXA.mp3')
  end

  should 'does not trunc short filename' do
    assert_equal 'filename.mp3', short_filename('filename.mp3')
  end

  include ActionView::Helpers::NumberHelper
  should 'format float to money as Brazillian currency' do
    assert_equal 'R$10,00', float_to_currency(10.0)
  end

  protected

  def url_for(args = {})
    args
  end
  def content_tag(tag, content, options = {})
    content.strip
  end
  def javascript_tag(any)
    ''
  end
  def link_to(label, action, options = {})
    label
  end
  def check_box_tag(name, value = 1, checked = false, options = {})
    name
  end
  def stylesheet_link_tag(arg)
    arg
  end

end
