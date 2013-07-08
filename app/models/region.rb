# Region is a special type of category that is related to geographical issues. 
class Region < Category
  has_and_belongs_to_many :validators, :class_name => 'Organization', :join_table => :region_validators

  require_dependency 'enterprise' # enterprises can also be validators

  def has_validator?
    validators.count > 0
  end

  named_scope :with_validators, :group => 'id',
    :joins => 'INNER JOIN region_validators on (region_validators.region_id = categories.id)'
  
end

require_dependency 'city'
require_dependency 'state'
