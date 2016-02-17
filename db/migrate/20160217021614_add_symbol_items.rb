class AddSymbolItems < ActiveRecord::Migration
  def change
    add_column :items, :symbol, :string
  end
end
