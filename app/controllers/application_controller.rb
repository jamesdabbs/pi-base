class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to new_user_session_url, alert: exception.message
  end

  def root
  end

  def unproven
    @theorems = Theorem.unproven.paginate page: params[:theorems], per_page: 15
    @traits   = Trait.unproven.paginate   page: params[:traits],   per_page: 30
  end
end
