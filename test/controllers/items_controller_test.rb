require 'test_helper'

class ItemsControllerTest < ActionController::TestCase

  describe "Items Controller Tests" do
 
    let(:tania) { users(:tania) }
    let(:anita) { users(:anita) }
    let(:air_nz) { stocks(:airnz_stock) }
    let(:auckland) { stocks(:auckland_stock) }

    describe "actions performed by a non logged in user" do 

      it "doesn't allow current data to be retrieved" do 
        xhr :get, :retrieve_current_data
        assert_response 401
        assert_nil assigns(:quote_data)
        assert_nil assigns(:subscriptions_count)
      end
  
      it "doesn't allow historic data to be retrieved" do 
        xhr :get, :retrieve_historic_data
        assert_response 401
        assert_nil assigns(:all_historic_data)
      end
  
      it "doesn't allow the capture process to be started" do 
        xhr :get, :start_capture
        assert_response 401
      end

      it "doesn't allow current data to be retrieved" do 
        xhr :get, :stop_capture
        assert_response 401
      end

    end
    
    describe "actions that can be performed by logged in user" do

      before do 
        sign_in tania
      end

      it "allows current data to be retrieved" do
        xhr :get, :retrieve_current_data
        assert_response 200
        assert_not_nil assigns(:quote_data)
        @quote_data = @controller.instance_variable_get('@quote_data')
      end


      it "allows current data to be retrieved and detect change" do
        subscription_stock_id = Stock.find(tania.subscriptions.second.stock_id).symbol
        item = Item.all.where(symbol: subscription_stock_id).order('created_at DESC').first
        item.update_attribute(:last_price, 15.25)
        xhr :get, :retrieve_current_data
        assert_response 200
        assert_not_nil assigns(:quote_data)
        @quote_data = @controller.instance_variable_get('@quote_data')
      end

      it "allows historic data to be retrieved" do 
        Item.create(name: air_nz.name, symbol: air_nz.symbol, last_price: 11.20, last_datetime: DateTime.now - 5.hours)
        Item.create(name: auckland.name, symbol: auckland.symbol, last_price: 6.80, last_datetime: Date.today - 3.hours)
        Item.create(name: auckland.name, symbol: auckland.symbol, last_price: 6.40, last_datetime: DateTime.now - 2.hours)
        xhr :get, :retrieve_historic_data
        assert_response 200
        @historic_data = @controller.instance_variable_get('@all_historic_data')
        assert_not_nil assigns(:all_historic_data)
        @historic_data.size.must_equal 2 #since user tania not interested in air nz
      end

      it "allows stop capture to be run" do 
        xhr :get, :stop_capture
        assert_response :redirect
        assert_equal 'YFExtractor has successfully stopped the capture process.', flash[:success]
      end

      it "allows start capture to be run" do 
        xhr :get, :start_capture
        assert_response :redirect
        assert_equal 'YFExtractor has successfully started the capture process.', flash[:success]
      end

    end

    describe "single user subscriptions" do

      before do
        sign_out tania
        sign_in anita
      end

      it "can handle single user subscriptions" do
        xhr :get, :retrieve_current_data
        assert_response 200
        assert_not_nil assigns(:quote_data)
      end

      it "can handle change in single user subscriptions" do
        subscription_stock_id = Stock.find(anita.subscriptions.first.stock_id).symbol
        item = Item.all.where(symbol: subscription_stock_id).order('created_at DESC').first
        item.update_attribute(:last_price, 15.25)
        xhr :get, :retrieve_current_data
        assert_response 200
        assert_not_nil assigns(:quote_data)
      end

    end

  end

end