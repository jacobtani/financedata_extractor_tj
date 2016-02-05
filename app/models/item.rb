class Item 
  include ActiveAttr::Model
  
  attribute :name
  attribute :last_trade_date
  attribute :last_trade_price

validates_presence_of :name, :last_trade_date, :last_trade_time, :last_trade_price

end