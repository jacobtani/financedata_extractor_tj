class CreateSiteconfigs < ActiveRecord::Migration
  def change
    create_table :site_configs do |t|
      t.boolean :running_start
      t.boolean :running_stop
    end
  end
end
