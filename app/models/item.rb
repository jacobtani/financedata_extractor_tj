require 'net/http'
require 'open-uri'
require 'tempfile'
require 'fileutils'

class Item < ActiveRecord::Base

  #Get historic data for each stock and build them into one big list
  def self.get_history_data()
    @all_historic_data = Array.new
    Rails.configuration.stock_symbols.each do |stock|
      @i= Item.select('distinct on (last_price) *').where(symbol: stock).limit(5)
      @historic_data = @i.sort_by { |i| i[:created_at] }.reverse!
      @all_historic_data.push @historic_data
    end
    @all_historic_data
  end

  #Build the url to query the yahoo api based on stock data 
  def self.form_url 
    initial_url = 'https://query.yahooapis.com/v1/public/yql?q=select%20Name%2C%20LastTradePriceOnly%2C%20Symbol%2C%20LastTradeDate%2C%20LastTradeWithTime%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22'
    Rails.configuration.stock.each do |h|
      initial_url = [initial_url, h].join('')
      initial_url = [initial_url, '%22%2C%20%22'].join('')
    end
    initial_url = [initial_url, '%22%20)&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys'].join('')  
  end

  #Get the current stock data
  def self.current_data
    result = ItemsInteractor.call
    @quote_data = result.success? ? result.quote_data : []
    @changed = Hash.new
    @quote_data.each do |item|
      #Check whether item price has changed or not
      @items = Item.all.where(name: item['Name']).order('created_at DESC').first
      @last_price = (item["LastTradePriceOnly"].to_f).round(2)
      if @items.present? && @items.last_price != @last_price
          @changed[item['Name']] = true 
      else
        @changed[item['Name']] = false 
      end
      Item.create(name: item['Name'], last_datetime: item['LastTradeDate'], last_price: @last_price, symbol: item['Symbol'])
    end
    @quote_data
    #send quote data and changed data status to client
    MessageBus.publish('/new_quote_data', quote_data: @quote_data, changed_data: @changed)
    @quote_data
  end

  #Generate the pdf of the current stock data
  def self.generate_pdf()
    av = ActionView::Base.new()
    av.view_paths = ActionController::Base.view_paths
    av.class_eval do
      include Rails.application.routes.url_helpers
      include ApplicationHelper
    end
    pdf_html = av.render :template => "items/retrieve_current_data.pdf.erb",:locals => {:quote_data => Item.current_data}
    # use wicked_pdf gem to create PDF from the doc HTML
    doc_pdf = WickedPdf.new.pdf_from_string(pdf_html, :page_size => 'Letter')
    #assemble filename
    filename = "Current-Stock-Prices-" + (DateTime.now.to_s)
    filename.gsub!(/ /,'-')
    begin 
      file = Tempfile.new([filename, '.pdf']) 
      file.binmode
      file.write doc_pdf
      #make the directory to write the file to
      FileUtils::mkdir_p Dir.home + '/stock_pdfs'
      #set file path
      path = Dir.home + "/stock_pdfs/" + filename + '.pdf'
      #download file contents to the path specified
      open(path, 'wb') do |f|
        f << doc_pdf
      end
      file.close
    end
  end

end