set :output, "log/cron_log.log"

#Retrieve current stock market data 
every 1.minutes do
  runner "StockRecord.get_current_data", :environment => "development"
end

#Create text report every hour of stock data
every :hour do
every 1.minutes do
  runner "StockRecord.generate_pdf", :environment => "development"
end
