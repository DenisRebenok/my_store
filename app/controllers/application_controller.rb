class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  protect_from_forgery with: :exception

  before_action :generate_menu

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

  def generate_menu
    mmmenu do |l1|
      l1.add "All Items", items_path do |l2|
        l2.add "Computers",   items_path(category: 'computers'), paths: [[items_path, 'get', { category: 'computers' }]]
        l2.add "Toys",   items_path(category: 'toys'), paths: [[items_path, 'get', { category: 'toys' }]]
      end
      l1.add "Cart", cart_path
    end 
  end

end
