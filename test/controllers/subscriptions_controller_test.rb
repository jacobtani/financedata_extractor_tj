require 'test_helper'

class SubscriptionsControllerTest < ActionController::TestCase

  describe "Subscriptions Controller Tests" do

    let(:tania) { users(:tania) }
    let(:iain) { users(:iain) }
    let(:auckland) { stocks(:auckland_stock) }
    let(:air_nz) { stocks(:airnz_stock) }
    let(:first_sub) { subscriptions(:one) }
    let(:second_sub) { subscriptions(:two) }
    let(:third_sub) { subscriptions(:three) }

    describe "actions by a non logged in user" do

      it "raises an unauthorised error when trying to add a subscription" do
        post :create, subscription: { stock_id: auckland.id, user_id: nil }, format: :js
        assert_response 401
        @controller.instance_variable_get('@subscription').must_equal nil
      end

    end

    describe "Actions by a logged in user" do

      before do 
        sign_in tania
      end

      it "should allow a user to add a subscription" do
        original_subs_count = iain.subscriptions.count
        post :create, subscription: { stock_id: air_nz.id, user_id: iain.id}, format: :js
        assert_response :success
        @controller.instance_variable_get('@subscription').stock_id.must_equal air_nz.id
        iain.subscriptions << @controller.instance_variable_get('@subscription')
        iain.reload.subscriptions.count.must_equal original_subs_count + 1
      end

      it "should allow a user to edit their subscription" do
        patch :update, id: first_sub, subscription: {stock_id: air_nz.id, user_id: tania.id}, format: :js
        assert_response :success
        first_sub.reload.stock_id.must_equal air_nz.id
      end

      it "should allow a user to delete a stock from their subscriptions" do
        assert_difference ->{ tania.subscriptions.count }, -1 do
          delete :destroy, id: second_sub
        end
        assert_response :redirect
      end

    end

    describe "A user can only manage their own subscriptions" do

      before do 
        sign_in tania
      end

      it "shouldn't allow another user to update another user's subscription" do
        assert_raises(ActiveRecord::RecordNotFound) do
          patch :update, id: third_sub, subscription: {stock_id: air_nz.id, user_id: iain.id}, format: :js
        end
      end

      it "only allows a user to delete their own subscription" do
        assert_raises(ActiveRecord::RecordNotFound) do
          delete :destroy, id: third_sub
        end
      end


    end

  end

end