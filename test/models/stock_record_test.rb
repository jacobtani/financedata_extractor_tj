require 'test_helper'

class StockRecordTest < ActiveSupport::TestCase

  describe "StockRecord Model Tests" do

    let(:stock_record_one)     { stock_records(:first_stock_record)   } 
    let(:iain)         { users(:iain) } 

    describe "Valid stock records" do 

      it "should have a date, price, name and symbol" do 
        stock_record_one.valid?.must_equal true
      end

    end

  end

end
