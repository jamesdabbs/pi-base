class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def root
  end

  def unproven
    @theorems = Theorem.unproven.paginate page: params[:theorems], per_page: 15
    @traits   = Trait.unproven.paginate   page: params[:traits],   per_page: 30
  end
end
