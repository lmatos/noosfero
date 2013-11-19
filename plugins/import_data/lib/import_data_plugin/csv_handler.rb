require 'csv'

class ImportDataPlugin::CSVHandler

  def parse(content,separator = ',')
      csv = {}
      reader = CSV.parse(content, separator) 
      
      csv['header'] = reader.shift
      csv['rows'] = []
    
    reader.each do |row|
      csv['rows'] << row
    end

    csv
  end

end
