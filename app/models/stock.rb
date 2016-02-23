class Stock < ActiveRecord::Base
has_many :subscriptions, dependent: :destroy

  #Build the label to display in dropdown where stocks displayed
  def label
    "#{symbol} [#{name}]"
  end

end