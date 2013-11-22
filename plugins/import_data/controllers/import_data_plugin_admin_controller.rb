require_dependency 'uploaded_file'
require 'csv'

class ImportDataPluginAdminController < AdminController

  append_view_path File.join(File.dirname(__FILE__) + '/../views')
  
  SEPARATORS = { 'semicolon' => ';', 'comma' => ',', 'space' => ' '}

  ENTERPRISE_KEYS = {
     _("Name")          => "name",
     _("Contact phone") => "contact_phone",
     _("Identifier")    => "identifier",
     _("Adress")        => "address"
  }
  
  ENTERPRISE_DATA_KEYS = {
    _("Economic activity")            => "economic_activity",
    _("Historic and current context") => "historic_and_current_context",
    _("State")                        => "state",
    _("Foundation year")              => "foundation_year",
    _("Legal form")                   => "legal_form",
    _("Activities short description") => "activities_short_description",
    _("Contact email")                => "contact_email",
    _("ZIP")                          => "zip_code",
    _("District")                     => "district",
    _("Display name")                 => "display_name",
    _("Description")                  => "description",
    _("Acronym")                      => "acronym",
    _("City")                         => "city",
    _("Address reference")            => "address_reference",
    _("Country")                      => "country",
    _("Organization website")         => "organization_website",
    _("Contact person")               => "contact_person",
    _("Description")		      => "description",
    _("Management information")	      => "management_information",
    _("Tag list")		      => "tag_list",
    _("Template id")		      => "template_id",
    _("Business name")		      => "business_name",
  }
    
  def index
    render 'upload_file'
  end

  def select_fields
    post = params[:upload]['csv']
    sep = params[:separator]
    path_to_csv = File.join("tmp", "import_data.csv")
    path_to_sep = File.join("tmp", "sep.txt")

    File.open(path_to_csv, "wb") { |f| f.write(post.read) }
    File.open(path_to_sep, "wb") { |f| f.write(SEPARATORS[sep]) }

    handler = ImportDataPlugin::CSVHandler.new
    @csv = handler.parse(path_to_csv, SEPARATORS[sep])
    @keys = {_('None selected') => 'none'}.merge(ENTERPRISE_KEYS).merge(ENTERPRISE_DATA_KEYS)

    render 'select_fields'
  end


  def confirm_fields
    @relations = {}
    params[:relations].keys.each do |key|
      @relations[key] = params[:relations][key] if params[:relations][key] != 'none'
    end
    render 'confirm_fields'
  end

  def perform_migration
    handler = ImportDataPlugin::CSVHandler.new
    sep = File.open('tmp/sep.txt','r').read
    @csv = handler.parse("tmp/import_data.csv",sep)
    @relations = params[:relations]
    @error_log = []
    #begin
      @csv["rows"].each do |row|
        index = 0
        e = Enterprise.new
        e.data['fields_privacy'] = {}

        @csv["header"].each do |csv_field|
          unless @relations[csv_field].to_s.empty?
            if @relations[csv_field].to_s == "identifier"
              assign_enterprise_field(
                @relations[csv_field].to_s,
                e,
                row[index].to_s.to_slug
              )
            else 
              t = e[@relations[csv_field].to_s]
              assign_enterprise_field(
                @relations[csv_field].to_s,
                e,
                (t.nil? ? row[index].to_s : t + ' ' + row[index].to_s)
              ) 
            end
          end        
          index +=1
        end
        e.save
      end
      render "result", :success => true
    #rescue  
    #  render "result", :success => false
    #end
  end

  private

  def assign_enterprise_field(field,enterprise,value)
    value = value.downcase == 'xxx' ? '' : value
    if ENTERPRISE_KEYS.values.include? field
      enterprise[field] = value
      puts '='*10, "Assign #{field} = #{value}"
    elsif ENTERPRISE_DATA_KEYS.values.include? field
      puts '='*10, "Assign data #{field} = #{value}"
      enterprise.data[field] = value
      enterprise.data['fields_privacy'][field] = 'public'
    end  
  end
end

