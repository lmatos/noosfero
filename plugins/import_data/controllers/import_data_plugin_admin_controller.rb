require_dependency 'uploaded_file'
require 'csv'

class ImportDataPluginAdminController < AdminController

  append_view_path File.join(File.dirname(__FILE__) + '/../views')
  
  def index
    render 'upload_file'
  end

  def select_fields
    post = params[:upload]['csv']
    path = File.join("tmp", "import_data.csv")
    File.open(path, "wb") { |f| f.write(post.read) }

    handler = ImportDataPlugin::CSVHandler.new
    @csv = handler.parse(path) 

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
      @csv = handler.parse("tmp/import_data.csv")
      @relations = params[:relations]
      @error_log = []

      @csv["rows"].each do |row|
        begin
          index = 0
          e = Enterprise.new

          @csv["header"].each do |csv_field|
            unless @relations[csv_field].to_s.empty?
              if @relations[csv_field].to_s == "identifier"
                e[@relations[csv_field].to_s] = row[index].to_s.to_slug
              else 
                e[@relations[csv_field].to_s] = row[index].to_s
              end
            end
            
            index +=1
          end
          
          e.save
        rescue
          @error_log << {
              :message => e.errors.full_messages,
              :indentifier => e.identifier
          }
        end
      end
      
      render :text => "ola mundo", :success => true
  end

end

