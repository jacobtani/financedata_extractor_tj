require 'net/http'

 class ItemsController < ApplicationController
  
  def index
    @items = Item.all
  end

  def show
    @item = Item.find(params[:id])
  end

  def retrieve_current_data
    @item = Item.new(params[:item])
    if @item.save
      Item.current_data(@item.id)
      @item.reload
    end
    sleep(20)
    @item.reload
    @quote_data = @item.reload.data
  end

end