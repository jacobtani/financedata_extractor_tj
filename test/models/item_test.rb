require 'test_helper'

class ItemTest < ActiveSupport::TestCase

  describe "Item Model Tests" do

    let(:item_one)     { items(:first_item)   } 
    let(:iain)         { users(:iain) } 

    describe "Valid items" do 

      it "should have a date, price, item name and symbol" do 
        item_one.valid?.must_equal true
      end
    end

  end

end
