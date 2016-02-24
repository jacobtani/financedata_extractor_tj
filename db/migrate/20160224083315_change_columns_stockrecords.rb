class ChangeColumnsStockrecords < ActiveRecord::Migration
  def change
    remove_column :stock_records, :symbol
    remove_column :stock_records, :name
    add_reference :stock_records, :stock, index: true
  end
end
