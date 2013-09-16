class FormulaeController < ApplicationController
  def search
    if @q = params[:q]
      @results = begin
        @formula = Formula.load @q.gsub /\&/, '+'
        Space.where(id: @formula.spaces).paginate pagination
      rescue Formula::ParseError => e
        @error = e
        Property.search @q, pagination
      end
      @results &&= @results
    end
  end

  private #----------

  def pagination
    { page: params[:page], per_page: 30 }
  end
end
