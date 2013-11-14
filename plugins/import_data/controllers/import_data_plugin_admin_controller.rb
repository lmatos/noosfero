require_dependency 'uploaded_file'
require 'csv'

class ImportDataPluginAdminController < AdminController

  append_view_path File.join(File.dirname(__FILE__) + '/../views')
  
  def index
    render 'upload_file'
  end

  def select_fields
    post = params[:upload]['csv']
    
    handler = ImportDataPlugin::CSVHandler.new
    @csv = handler.parse(post.read) 
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
      
      @csv["rows"].each do |row|
        index = 0
        e = Enterprise.new
        @csv["header"].each do |csv_field|
          e.attributes[relations[csv_field]] =  row[index]
          e.identifier = 54
          index +=1 
        end
        e.save
        render :text => "re2323sult", :success => true
      end
  
  end

end

