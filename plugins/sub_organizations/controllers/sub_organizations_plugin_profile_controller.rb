class SubOrganizationsPluginProfileController < ProfileController
  append_view_path File.join(File.dirname(__FILE__) + '/../views')

  before_filter :organizations_only

  def children
    children = SubOrganizationsPlugin::Relation.children(profile)
    @communities = children.communities
    @enterprises = children.enterprises
    @full = true

    if !params[:type]
      @communities = SubOrganizationsPlugin.limit(@communities)
      @enterprises = SubOrganizationsPlugin.limit(@enterprises)
      @full = false
    else
      @communities = @communities.paginate(:per_page => 12, :page => params[:npage])
      @enterprises = @enterprises.paginate(:per_page => 12, :page => params[:npage])
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
