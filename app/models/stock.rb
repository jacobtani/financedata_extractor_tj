class Stock < ActiveRecord::Base

  #Build the label to display in dropdown where stocks displayed
  def label
    "#{symbol} [#{name}]"
  end

end