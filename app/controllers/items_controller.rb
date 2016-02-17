require 'net/http'

 class ItemsController < ApplicationController
  
  def index
    @items = Item.all
  end

  def show
    @item = Item.find(params[:id])
  end

  def retrieve_current_data
    @quote_data = Item.current_data
  end

  def search_history
    @history_data = Item.get_history_data(params[:search])
  end

  def search_all_history
    @all_data = Item.get_history_data
  end


  def start_capture
    system('whenever --update-crontab')
    redirect_to retrieve_data_path
  end

  def stop_capture
    system('whenever -c')
    redirect_to retrieve_data_path
  end

end