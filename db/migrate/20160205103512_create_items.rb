class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name 
      t.datetime :last_trade_date
      t.datetime :last_trade_time
      t.float :last_trade_price
      t.float :price_change
    end
  end
end


