class ChangeSubscriptionsColumn < ActiveRecord::Migration
  def change
    add_reference :subscriptions, :stock, index: true
    remove_column :subscriptions, :symbol
  end
end
