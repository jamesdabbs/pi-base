class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to new_user_session_url, alert: exception.message
  end

  def root
  end

  def help
  end

  def errata
    pairs = [[73, 10], [13, 54], [14, 54], [108, 20], [29, 54], [97, 54]]
    @traits = pairs.map { |s, p| Trait.where(space_id: s, property_id: p).first }
  end

  def unproven
    @theorems = Theorem.unproven.paginate page: params[:theorems], per_page: 15
    @traits   = Trait.unproven.paginate   page: params[:traits],   per_page: 30
  end
end
