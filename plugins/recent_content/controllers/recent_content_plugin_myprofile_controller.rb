require File.dirname(__FILE__) + '/recent_content_plugin_module'

class RecentContentPluginMyprofileController < MyProfileController

  append_view_path File.join(File.dirname(__FILE__) + '/../views')

  include RecentContentPluginController 

end
