require 'test_helper'

class StockTest < ActiveSupport::TestCase

  describe "Stock Model Tests" do
  
    let(:xero)     { stocks(:xero_stock)   } 
    
    it "a valid stock has a name and symbol" do 
      assert xero.valid?
    end

    it "gives the correct label for a stock when displaying it in the dropdown" do 
      xero.label.must_equal "XRO.NZ [Xero Ltd]" 
    end

  end

end
