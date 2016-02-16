class AddColumnsItem < ActiveRecord::Migration
  def change
    add_column :items, :changed_value, :boolean, default:false
    remove_column :items, :data, :text
    add_column :items, :name, :string
    add_column :items, :last_datetime, :datetime
    add_column :items, :last_price, :float
    add_column :items, :created_at, :datetime, null:false
  end
end
