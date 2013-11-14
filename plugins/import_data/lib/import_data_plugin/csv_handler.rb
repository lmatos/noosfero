require 'csv'

class ImportDataPlugin::CSVHandler

  def parse(content)
      csv = {}
      reader = CSV.parse(content, ';')
      
      csv['header'] = reader.shift
      csv['rows'] = []
    
    reader.each do |row|
      csv['rows'] << row
    end

    csv
  end

end
