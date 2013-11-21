require_dependency 'uploaded_file'
require 'csv'

class ImportDataPluginAdminController < AdminController

  append_view_path File.join(File.dirname(__FILE__) + '/../views')
  
  SEPARATORS = { 'semicolon' => ';', 'comma' => ',', 'space' => ' '}

  ENTERPRISE_KEYS = {
    "name" => _("Name"),
    "contact_phone" => _("Contact phone"),
    "identifier" => _("Identifier"),
    "address" => _("Adress"), 
  }
  
  ENTERPRISE_DATA_KEYS = {
    "economic_activity" => _("Economic activity"),
    "historic_and_current_context" => _("Historic and current context"),
    "state" => _("State"),
    "foundation_year" => _("Foundation year"),
    "legal_form" => _("Legal form"),
    "activities_short_description" => _("Activities short description"),
    "contact_email" => _("Contact email"),
    "zip_code" => _("ZIP"),
    "district" => _("District"),
    "display_name" => _("Display name"),
    "description" => _("Description"),
    "acronym" => _("Acronym"),
    "city" => _("City"),
    "address_reference" => _("Address reference"),
    "country" => _("Country"),
    "organization_website" => _("Organization website"),
    "contact_person" => _("Contact person"),
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

    render 'select_fields'
  end


  def confirm_fields
    @relations = {}
    params[:relations].keys.each do |key|
      @relations[key] = params[:relations][key]
    end
    render 'confirm_fields'
  end

  def perform_migration
    handler = ImportDataPlugin::CSVHandler.new
    sep = File.open('tmp/sep.txt','r').read
    @csv = handler.parse("tmp/import_data.csv",sep)
    @relations = params[:relations]
    @error_log = []
    begin
      @csv["rows"].each do |row|
        index = 0
        e = Enterprise.new

        @csv["header"].each do |csv_field|
          unless @relations[csv_field].to_s.empty?
            puts "="*80, row[index].to_s.nil?, "="*80
            if @relations[csv_field].to_s == "identifier"
              e[@relations[csv_field].to_s] = row[index].to_s.to_slug
            else 
              t = e[@relations[csv_field].to_s]
              e[@relations[csv_field].to_s] = t.nil? ? row[index].to_s : t + ' ' + row[index].to_s
            end
          end        
          index +=1
        end
        e.save
      end
      render "result", :success => true
    rescue  
      render "result", :success => false
    end
  end

  private

  def assign_enterprise_field(field,enterprise,value)
    if ENTERPRISE_KEYS.include? field
      enterprise[field] = value
    elsif ENTERPRISE_DATA_KEYS.include? field
      enterprise.data[field] = value
    end  
  end
end

