class Stock < ActiveRecord::Base

  def label
    "#{symbol} [#{name}]"
  end

end