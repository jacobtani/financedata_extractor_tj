require 'net/http'

class Item < ActiveRecord::Base

  def self.get_history_data(item_code)
    uri= 'https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.historicaldata%20where%20symbol%20%3D%20%22'+ item_code+ '%22%20and%20startDate%20%3D\'2015-02-11\'%20and%20endDate%20%3D\'2016-02-18\'%20order%20by%20endDate%20DESC%20LIMIT%205&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys'
    url = URI.parse(uri)
    data = Net::HTTP.get_response(url).body
    xml_data = Hash.from_xml(data)
    @history_data = xml_data ["query"]["results"]["quote"] if xml_data.present?
  end

end