class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.text :data
    end
  end
end
