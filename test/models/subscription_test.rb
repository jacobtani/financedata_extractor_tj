require 'test_helper'

class SubscriptionTest < ActiveSupport::TestCase

  describe "Subscription Model tests" do
    let(:tania) { users(:tania) }
    let(:auckland) { stocks(:auckland_stock) }
    let(:first_sub) { subscriptions(:one) }
    let(:second_sub) { subscriptions(:two) }

    it "a subscription has a valid combo of stock id and user id" do 
      first_sub.valid?.must_equal true
    end

    it "does not allow a subscription to be created by the user for the same stock twice" do 
      sub = Subscription.new(user_id: tania.id, stock_id: auckland.id)
      sub.valid?.must_equal false
      sub.errors.messages.to_s.must_equal "{:user_id=>[\"has already been taken\"]}" 
    end

  end

end
