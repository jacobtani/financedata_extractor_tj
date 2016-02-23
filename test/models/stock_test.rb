require 'test_helper'

class StockTest < ActiveSupport::TestCase

  describe "Stock Model tests" do
		let(:spark)     { stocks(:spark)   } #spark stock
	
		it "a valid stock has a name and symbol" do 
			assert spark.valid?
		end

		it "gives the correct label for a stock when displaying it in the dropdown" do 
			spark.label.must_equal "SPK.NZ [Spark New Zealand]"	
		end

  end

end
