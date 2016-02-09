require 'net/http'

class ItemsWorker
  include Sidekiq::Worker
  sidekiq_options unique_for: 10.minutes

  def perform(item_id)
    return if cancelled?
    logger.info("Working along")
    @item = Item.find(item_id)
    url_c = Item.form_url
    url = URI.parse(url_c)
    data = Net::HTTP.get_response(url).body
    xml_data = Hash.from_xml(data)
    @quote_data = xml_data ["query"]["results"]["quote"] if xml_data.present?
    @item.update_attributes(data: @quote_data)
    @item.save
  end

  def cancelled?
    Sidekiq.redis {|c| c.exists("cancelled-#{jid}") }
  end

  def self.cancel!(jid)
    Sidekiq.redis {|c| c.setex("cancelled-#{jid}", 86400, 1) }
  end

end