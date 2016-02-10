require 'net/http'

 class ItemsController < ApplicationController
  
  def index
    @items = Item.all
  end

  def show
    @item = Item.find(params[:id])
  end

  def retrieve_current_data
    @item = Item.create(data: nil)
    ItemsWorker.perform_async(@item.id)
    @item.reload
    sleep(20)
    @item.reload
    @quote_data = @item.reload.data
  end

  def search_history
    params[:search].present?
    @search_item = params[:search]
    @history_data = Item.get_history_data(@search_item)
  end

  def search_all_history
    @no_data = "Historic data does not exist for: "
    @all_data = Array.new
      Rails.configuration.stock_symbols.each do |stock|
        @history_data = Item.get_history_data(stock)
        @no_data.concat(' ' + stock) if @history_data == [] 
        @all_data.push @history_data unless @history_data == []
      end
    flash[:info] = @no_data 
  end


  def start_capture
  end

  def stop_capture
  end

end