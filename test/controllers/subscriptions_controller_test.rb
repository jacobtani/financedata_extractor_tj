require 'test_helper'

class SubscriptionsControllerTest < ActionController::TestCase

  describe "Subscriptions Controller Tests" do

    let(:tania) { users(:tania) }
    let(:first_sub) { subscriptions(:one_subscription) }
    let(:second_sub) { subscriptions(:two_subscription) }
    let(:yahoo) { stocks(:yahoo) }

    describe "actions by a non logged in user" do 

      it "raises an exception when a non logged in user tries to add a subscription" do 
        assert_raises(NoMethodError) {post :create, subscription: { stock_id: yahoo.id, user_id: nil }, format: :js }
        @controller.instance_variable_get('@subscription').must_equal nil
      end
    
    end

    describe "Actions by a logged in user" do 

      before do 
        sign_in tania
      end

      it "should allow a user to add a subscription" do 
      end

      it "should allow a user to edit their subscription" do 
      end

      it "should allow a user to delete a stock from their subscriptions" do 
      end

   end

  end

end