class SiteConfigsController < ApplicationController

  def update
    @site_config = SiteConfig.active
    @site_config.update_attributes site_config_params
  end

  private

  def site_config_params
    params.require(:site_config).permit(
      :running_start,
      :running_end
    )
  end
end
