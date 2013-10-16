require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../../lib/sub_organizations_block'

class SubOrganizationsBlockTest < ActiveSupport::TestCase

  def setup
    @block = SubOrganizationsBlock.new
  end

  attr_reader :block

  should 'have both as default organization_type' do
    assert_equal "both", block.organization_type
  end

end
