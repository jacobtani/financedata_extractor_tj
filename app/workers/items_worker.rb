require 'net/http'

class ItemsWorker
  include Sidekiq::Worker
  sidekiq_options unique_for: 10.minutes

  def perform(item_id)
    return if cancelled?
    logger.info("Working along")
    @item = Item.find(item_id)
    url = URI.parse('https://query.yahooapis.com/v1/public/yql?q=select%20Name%2C%20LastTradePriceOnly%2C%20LastTradeDate%2C%20LastTradeWithTime%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22CLH16.NYM%22%2C%20%22BZJ16.NYM%22%2C%20%22HOH16.NYM%22%2C%20%22NGH16.NYM%22%2C%20%22RBH16.NYM%22%2C%20%22HGG16.CMX%22%2C%20%22GCG16.CMX%22%2C%20%22PAG16.NYM%22%2C%20%22PLH16.NYM%22%2C%20%22SIG16.CMX%22%20)&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys')
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