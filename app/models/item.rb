class Item < ActiveRecord::Base

validates_presence_of :name, :last_trade_date, :last_trade_time, :last_trade_price

end