require_dependency 'uploaded_file'
require 'csv'

class ImportDataPluginAdminController < AdminController

  append_view_path File.join(File.dirname(__FILE__) + '/../views')

  def index
  end

  def import_data
    post = UploadedFile.save(params[:upload])

   reader = CSV.open("public/data/csv/Sample.csv",'r') 

      row1 = reader.shift
      row2 = reader.shift
      row3 = reader.shift

      attributes = Array.new
      row2.map{ |m| attributes << m.split(',') }

      attributes.each { |attri| puts attri}

      row2.map
    #render :text => "File has been uploaded successfully"
  end

end

