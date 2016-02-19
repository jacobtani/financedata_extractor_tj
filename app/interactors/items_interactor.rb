class ItemsInteractor
  include Interactor

  def call
    url = URI.parse(Item.form_url)
    data = Net::HTTP.get_response(url).body #retrieve data from url
    xml_data = Hash.from_xml(data) #turn data to xml
    context.quote_data = xml_data ["query"]["results"]["quote"] if xml_data.present?
  end

 end