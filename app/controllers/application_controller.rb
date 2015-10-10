class ApplicationController < ActionController::Base
  before_filter :configure_permitted_parameters, if: :devise_controller?
  
  protect_from_forgery with: :exception

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :login
    devise_parameter_sanitizer.for(:account_update) << :email
  end

  private

  def render_403
    render file: "public/403.html", status: 403
  end

  def render_404
    render file: "public/404.html", status: 404
  end

  def check_if_admin
    render_403 unless params[:admin]
  end

end
