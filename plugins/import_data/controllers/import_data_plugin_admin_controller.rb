require_dependency 'uploaded_file'
require 'csv'

class ImportDataPluginAdminController < AdminController

  append_view_path File.join(File.dirname(__FILE__) + '/../views')

  def index
  end

  def import_data
    post = UploadedFile.save(params[:upload])
    CSV.foreach("public/data/csv/Sample.csv") do |row|
    	puts row.to_s+'\n'
    end
    #render :text => "File has been uploaded successfully"
  end

end

