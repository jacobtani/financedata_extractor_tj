require 'net/http'
require 'open-uri'
require 'tempfile'
require 'fileutils'

class StockRecord < ActiveRecord::Base
belongs_to :stock

  #Get historic data for each stock and build them into one big list
  def self.get_historical_data(user)
    @all_historic_data = Array.new
    if user.subscriptions
      user.subscriptions.each do |subs|
        @stock_record= StockRecord.select('distinct on (last_price) *').where(stock_id: subs.stock_id).limit(5)
        @historic_data = @stock_record.sort_by { |stock_record| stock_record[:created_at] }.reverse!
        @all_historic_data.push @historic_data
      end
    end
    @all_historic_data
  end

  #Build the url to query the yahoo api based on stock data 
  def self.form_url
    initial_url = 'https://query.yahooapis.com/v1/public/yql?q=select%20Name%2C%20LastTradePriceOnly%2C%20Symbol%2C%20LastTradeDate%2C%20LastTradeWithTime%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22'
    interested_stocks_ids = Subscription.select(:stock_id).distinct.pluck(:stock_id)
    interested_stocks_ids.each do |s|
        initial_url = [initial_url, Stock.find(s).symbol].join()
        initial_url = [initial_url, '%22%2C%20%22'].join('')
    end
    initial_url = [initial_url, '%22%20)&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys'].join('')  
  end

  #Get the current stock data
  def self.get_current_data
    @number_of_unique_subscriptions = Subscription.select(:stock_id).distinct.pluck(:stock_id)
    result = StockRecordsInteractor.call
    @quote_data = result.success? ? result.quote_data : []
    @changed = Hash.new
    #build parsable array of hashes
    if @number_of_unique_subscriptions.length == 1 
      @quote_data_new = handle_one_subscription(@quote_data)
    elsif @number_of_unique_subscriptions.length > 1 
      @quote_data_new = handle_many_subscriptions(@quote_data)
    end
    @quote_data_new.each do |stock_record|
      #Check whether stock price has changed or not
      stock = Stock.all.where(symbol: stock_record[:Symbol]).first
      @recent_stock_records = StockRecord.all.where(stock_id: stock.id).order('created_at DESC').first
      @price_float = (stock_record[:LastTradePriceOnly]).to_f #convert price to a float
      @last_price = (@price_float *100).round / 100.0 #round the price to 2dp
      @last_date = (DateTime.strptime(stock_record[:LastTradeDate], "%m/%d/%Y"))
      
      #check if stock prices have changed
      if @recent_stock_records.present? && @recent_stock_records.last_price != @last_price
        stock_record[:ChangedValue] = true
      else
        binding.pry
        stock_record[:ChangedValue] = false
      end      
      # add to db
      StockRecord.create(stock_id: stock.id, last_datetime: @last_date, last_price: @last_price)
    end

    #send quote data and changed data status to client using message bus
    MessageBus.publish('/new_quote_data', quote_data: @quote_data_new)
    @quote_data_new
  end

  #Build a parsable array of hashes when there is one subscription
  def self.handle_one_subscription(data)
    @quote_data_new = Array.new
    hash = {:Symbol => data['Symbol'], :Name => data['Name'], :LastTradeDate => data['LastTradeDate'], :LastTradePriceOnly => data['LastTradePriceOnly'], :LastTradeWithTime => data['LastTradeWithTime']}
    @quote_data_new.push hash
    @quote_data_new
  end

  #Build a parsable array of hashes when there is more than one subscription
  def self.handle_many_subscriptions(data)
    @quote_data_new = Array.new
    data.each do |d|
      hash = {:Symbol => d['Symbol'], :Name => d['Name'], :LastTradeDate => d['LastTradeDate'], :LastTradePriceOnly => d['LastTradePriceOnly'], :LastTradeWithTime => d['LastTradeWithTime']}
      @quote_data_new.push hash
    end
    @quote_data_new
  end

  #Generate the pdf of the current stock data
  def self.generate_pdf
    @users = User.all
    @users.each do |user|
      av = ActionView::Base.new()
      av.view_paths = ActionController::Base.view_paths
      av.class_eval do
        include Rails.application.routes.url_helpers
        include ApplicationHelper
      end
      pdf_html = av.render :template => "stock_records/retrieve_current_data.pdf.erb",:locals => {:quote_data => StockRecord.get_current_data, :interested_stocks => StockRecord.retrieve_user_stocks_interested(user)}
      # use wicked_pdf gem to create PDF from the doc HTML
      doc_pdf = WickedPdf.new.pdf_from_string(pdf_html, :page_size => 'Letter')
      #assemble filename
      filename = "Current-Stock-Prices-" + (DateTime.now.to_s)
      filename.gsub!(/ /,'-')
      #write file to tempfile
      begin 
        file = Tempfile.new([filename, '.pdf']) 
        file.binmode
        file.write doc_pdf
        #make the directory to write the file to
        FileUtils::mkdir_p Dir.home + '/stock_pdfs'
        #set file path to user's home directory within the stock_pdfs folder
        path = Dir.home + "/stock_pdfs/" + filename + '.pdf'
        #download file contents to the path specified
        open(path, 'wb') do |f|
          f << doc_pdf
        end
        file.close
        #in case IO exception occurs whilst dealing with file
      rescue IOError => e
        puts e.message
      end
    end   
  end

  #Get the ids of stocks a user is interested in
  def self.retrieve_user_stocks_interested(user)
    @interested_stocks = user.subscriptions.pluck(:stock_id)  
  end

end