class FormulaeController < ApplicationController
  def search
    if q = params[:q]
      @formula = Formula.parse q
      @results = Space.where(id: @formula.spaces).paginate(
        page: params[:page], per_page: 30)
    end
  end
end