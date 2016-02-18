class SiteConfig < ActiveRecord::Base
  def self.active
    last || create(
      running_start: true,
      running_stop: false
       )
  end
end
