 class ItemsController < ApplicationController
  before_action :set_item, only: [:edit, :update, :show, :destroy]
  
  def index
    @items = Item.all
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new item_params
    respond_to do |format|
      if @item.save
        flash[:success] = "Item was created successfully."
        format.js { redirect_turbo admin_path}
      else
        format.js { render partial: 'shared/ajax_form_errors', locals: {model: @item}, status: 500 }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @item.update_attributes item_params
        flash[:success] = "Item was updated successfully."
        format.js {redirect_turbo admin_path}
      else
        format.js { render partial: 'shared/ajax_form_errors', locals: {model: @item}, status: 500 }
      end
    end
  end

  def destroy
    @item.destroy
    redirect_to admin_path
  end

  private

    def item_params
      params.require(:item).permit(:name, :last_trade_date, :last_trade_time, :last_trade_price)
    end

    def set_item
      @item = Item.find params[:id] rescue nil
      return not_found! unless @item
    end

end