class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :symbol, null: false
      t.references :user, index: true
    end
  end
end
