class MembersBlock < ProfileListBlock

  settings_items :show_join_leave_button, :type => :boolean, :default => false
  
  def self.description
    _('Members')
  end

  def default_title
    _('{#} members')
  end

  def help
    _('This block presents the members of a collective.')
  end

  def footer
    profile = self.owner
    lambda do
         data = []
	 data.push(link_to _('View all'), :profile => profile.identifier, :controller => 'profile', :action => 'members')

         if logged_in?
           if profile.members.include?(user)
            data.push(button(:delete, content_tag('span',  __('Leave community')), profile.leave_url,
              :class => 'leave-community',
              :title => _("Leave community"),
              :style => 'position: relative;'))
            data.push(button(:add, content_tag('span', __('Join')), profile.join_url,
              :class => 'join-community',
              :title => _("Join community"),
              :style => 'position: relative; display: none;'))
           else
            data.push(button(:delete, content_tag('span',  __('Leave community')), profile.leave_url,
              :class => 'leave-community',
              :title => _("Leave community"),
              :style => 'position: relative; display: none;'))
            data.push(button(:add, content_tag('span', __('Join')), profile.join_url,
              :class => 'join-community',
              :title => _("Join community"),
              :style => 'position: relative;'))
          end
        else
           data.push(button(:add, content_tag('span', _('Join')), profile.join_not_logged_url,
              :class => 'button with-text icon-add',
              :title => _('Join this community'),
              :style => 'position: relative;'))
        end

         data
    end
  end

  def profiles
    owner.members
  end

  def options
    data = []
    #data.push(checkbox())
    #data.push(_("show join leave button"))
     
  end


end
