 class StockRecordsController < ApplicationController
  before_action :authenticate_user!

  def retrieve_current_data
    @quote_data = StockRecord.get_current_data rescue nil
    @interested_stocks = StockRecord.retrieve_user_stocks_interested(current_user)
  end

  def retrieve_historic_data
    @all_historic_data = StockRecord.get_historical_data(current_user) rescue nil
  end

 def start_capture
   site_config = SiteConfig.active
   site_config.update_attributes(running_start: params[:running_start], running_stop: params[:running_stop])
   system('whenever --update-crontab') #start capture
   flash[:success] = I18n.t("start_capture")
   redirect_to retrieve_current_data_path
 end

 def stop_capture
   site_config = SiteConfig.active
   site_config.update_attributes(running_start: params[:running_start], running_stop: params[:running_stop])
   system('whenever -c') #stop capture
   flash[:success] = I18n.t("stop_capture")
   redirect_to retrieve_current_data_path
 end

end