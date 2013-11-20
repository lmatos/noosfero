require_dependency 'uploaded_file'
require 'csv'

class ImportDataPluginAdminController < AdminController

  append_view_path File.join(File.dirname(__FILE__) + '/../views')
  
  SEPARATORS = { 'semicolon' => ';', 'comma' => ',', 'space' => ' '}
  
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
end

