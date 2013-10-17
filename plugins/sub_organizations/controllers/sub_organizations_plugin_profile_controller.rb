class SubOrganizationsPluginProfileController < ProfileController
  append_view_path File.join(File.dirname(__FILE__) + '/../views')

  before_filter :organizations_only

  def children
    sub_organizations = SubOrganizationsPlugin::Relation.children(profile)

    @sub_communities = sub_organizations.communities
    @sub_enterprises = sub_organizations.enterprises

    render 'sub_organizations'
  end

  private

  def organizations_only
    render_not_found if !profile.organization?
  end

end
