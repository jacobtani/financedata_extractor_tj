require 'net/http'

 class ItemsController < ApplicationController
#  include AbstractController::Rendering

  def index
    @items = Item.all
  end

  def retrieve_current_data
    @quote_data = Item.current_data
  end

  def search_all_history
    @all_data = Item.get_history_data
  end

 def start_capture
    site_config = SiteConfig.active
    site_config.update_attributes(running_start: params[:running_start], running_stop: params[:running_stop])
    system('whenever --update-crontab')
    redirect_to retrieve_data_path
  end

  def stop_capture
    site_config = SiteConfig.active
    site_config.update_attributes(running_start: params[:running_start], running_stop: params[:running_stop])
    system('whenever -c')
    redirect_to retrieve_data_path
  end

  def generate_pdf_reports
    data = render_to_string pdf: "filename", template: "/items/retrieve_current_data.pdf.erb", encoding: "UTF-8", footer: { right: '[page] of [topage]' }
    file = Item.my_method(data)
    send_file file.path
  end

end