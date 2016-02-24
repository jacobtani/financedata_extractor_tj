class RenameTableItems < ActiveRecord::Migration
  def change
    rename_table :items, :stock_records
  end
end
