# == Schema Information
#
# Table name: items
#
#  id                            :integer          not null, primary key
#  name                          :string(255)
#  created_at                    :datetime
#  updated_at                    :datetime

require 'test_helper'

class ItemTest < ActiveSupport::TestCase

  describe "Item" do
	let(:spark)     { items(:spark)   } #spark stock
	







  end

end
