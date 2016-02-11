namespace :items do
  desc "Get recent stock data"
  task :fetch => :environment do 
  	Item.current_data
  end
end