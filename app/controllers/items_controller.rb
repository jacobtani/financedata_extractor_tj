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
    #ItemsWorker.perform_in(1.minutes, @item.id)
    @blah = ItemsWorker.perform_async(@item.id)
    @item.reload
    sleep(20)
    @item.reload
    @item.reload
    logger.info ('item has a data of ' + @item.reload.data)
    @quote_data = @item.reload.data
  end

  def search_history
    @search_item = params[:search]
    @history_data = Item.get_history_data(@search_item)
  end

end