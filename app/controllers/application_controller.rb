class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def redirect_turbo(path)
    render js: "Turbolinks.visit('#{path}')"
  end

  def not_found!
    flash[:error] = 'Could not find object'
  end

end
