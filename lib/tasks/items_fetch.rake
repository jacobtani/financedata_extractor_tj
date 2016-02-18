namespace :items do
  desc "Get pdf stock data"
  task :fetch => :environment do 
  	@controller = ItemsController.new
  	@controller.generate_pdf_reports
  end
end