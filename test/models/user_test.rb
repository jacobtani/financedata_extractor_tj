require 'test_helper'

class UserTest < ActiveSupport::TestCase

  describe "User Model tests" do
    let(:tania) { users(:tania) }
    let(:iain) { users(:iain) }

    it "has a valid user" do
      tania.valid?.must_equal true 
    end

    it "builds the full name of a user correctly to display on the app" do 
      tania.full_name.must_equal "Tania Jacob"
    end

  end

end
