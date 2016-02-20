class ItemsInteractor
  include Interactor

  def call
    #build url to query to yahoo api
    url = URI.parse(Item.form_url)
    begin
      data = Net::HTTP.get_response(url).body #retrieve data from url
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
      puts e.message
    end
    xml_data = Hash.from_xml(data) #turn data to xml
    context.quote_data = xml_data ["query"]["results"]["quote"] if xml_data.present?
  end

 end