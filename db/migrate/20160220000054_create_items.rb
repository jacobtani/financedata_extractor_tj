class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.string :symbol
      t.float :last_price
      t.datetime :last_datetime
      t.timestamps null:false
    end
  end
end
