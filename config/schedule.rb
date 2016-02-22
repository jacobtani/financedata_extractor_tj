set :output, "log/cron_log.log"

#Retrieve current stock market data 
every 10.minutes do
  runner "Item.current_data", :environment => "development"
end

#Create text report every hour of stock data
every :hour do
  runner "Item.generate_pdf", :environment => "development"
end
