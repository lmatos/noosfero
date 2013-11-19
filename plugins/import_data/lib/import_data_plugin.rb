
class ImportDataPlugin < Noosfero::Plugin

  def self.plugin_name
    "Import Data"
  end

  def self.plugin_description
    _("A plugin that allows import CSV database.")
  end
    
  def js_files
    ['javascripts/script.js']
  end

end
