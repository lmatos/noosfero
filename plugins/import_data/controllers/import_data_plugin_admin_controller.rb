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

end

