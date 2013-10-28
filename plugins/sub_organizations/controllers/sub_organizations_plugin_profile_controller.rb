class SubOrganizationsPluginProfileController < ProfileController
  append_view_path File.join(File.dirname(__FILE__) + '/../views')

  before_filter :organizations_only

  def children
    children = SubOrganizationsPlugin::Relation.children(profile)
    @communities = children.communities
    @enterprises = children.enterprises

    unless params[:type]
      @communities = SubOrganizationsPlugin.limit(@communities)
      @enterprises = SubOrganizationsPlugin.limit(@enterprises)
    end

    render 'related_organizations'
  end

  def parents
    parents = SubOrganizationsPlugin::Relation.parents(profile)

    if params[:type]
      @organizations = parents
    else
      @organizations = SubOrganizationsPlugin.limit(parents)
    end

    render 'related_organizations'
  end


  private

  def organizations_only
    render_not_found if !profile.organization?
  end

end
