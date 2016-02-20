 class ItemsController < ApplicationController

  def retrieve_current_data
    @quote_data = Item.current_data rescue nil
    flash[:error] = 'Unable to retrieve current data' unless @quote_data
  end

  def retrieve_historic_data
    @all_historic_data = Item.get_history_data rescue nil
    flash[:error] = 'Unable to retrieve historic data' unless @all_historic_data
  end

 def start_capture
   site_config = SiteConfig.active
   site_config.update_attributes(running_start: params[:running_start], running_stop: params[:running_stop])
   system('whenever --update-crontab') #start capture
   flash[:success] = 'Capture process has been successfully started'
   redirect_to retrieve_current_data_path
 end

 def stop_capture
   site_config = SiteConfig.active
   site_config.update_attributes(running_start: params[:running_start], running_stop: params[:running_stop])
   system('whenever -c') #stop capture
   flash[:success] = 'Capture process has been successfully stopped'
   redirect_to retrieve_current_data_path
 end

end