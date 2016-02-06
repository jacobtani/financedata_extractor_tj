class Item < ActiveRecord::Base

  def self.current_data(item_id)
    @id = ItemsWorker.perform_async(item_id)
    @quote_data
  end

end