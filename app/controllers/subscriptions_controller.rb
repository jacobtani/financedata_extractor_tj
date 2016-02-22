class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: [:destroy, :edit, :update]

  def index
    @subscriptions = current_user.subscriptions rescue nil
  end

  def new
    @subscription = current_user.subscriptions.new
  end

  def create
    @subscription = current_user.subscriptions.new subscription_params
    respond_to do |format|
      if @subscription.save
        format.js { redirect_turbo subscriptions_path }
      else
        flash[:error] = "Already subscribed to this stock"
      end
    end
  end

  def update
    respond_to do |format|
      if @subscription.update_attributes subscription_params
        flash[:success] = "Subscription was updated successfully."
        format.js { redirect_turbo subscriptions_path}
      else
        flash[:error] = "Unable to perform changes"
      end
    end
  end

  def destroy
    @subscription.destroy
    redirect_to subscriptions_path
  end

  private

  def set_subscription
    @subscription = current_user.subscriptions.find params[:id] rescue nil
    return not_found! unless @subscription
  end

  def subscription_params
    params.require(:subscription).permit(:user_id, :symbol)
  end
end
