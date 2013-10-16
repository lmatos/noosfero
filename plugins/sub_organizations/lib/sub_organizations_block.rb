class SubOrganizationsBlock < ProfileListBlock

  settings_items :organization_type, :type => :string, :default => 'both'

  def self.description
    __('Sub Organizations')
  end

  def default_title
    case organization_type
    when 'enterprise'
      n__('{#} sub enterprise', '{#} sub enterprises', profile_count)
    when 'community'
      n__('{#} sub community', '{#} sub communities', profile_count)
    else
      n__('{#} sub organization', '{#} sub organizations', profile_count)
    end
  end

  def help
    _('This block displays sub organizations of this organization')
  end

  def profiles
    sub_organizations = SubOrganizationsPlugin::Relation.children(owner)
    case organization_type
    when 'enterprise'
      sub_organizations.enterprises
    when 'community'
      sub_organizations.communities
    else
      sub_organizations
    end
  end

  def footer
    profile = self.owner
    type = self.organization_type
    params = {:profile => profile.identifier, :controller => 'sub_organizations_plugin_profile', :action => 'children'}
    params[:type] = type if type == 'enterprise' || type == 'community'
    lambda do
      link_to _('View all'), params.merge(params)
    end
  end
end
