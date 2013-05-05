class FormulaeController < ApplicationController
  def search
    if @q = params[:q]
      begin
        @formula = Formula.load @q.gsub /\&/, '+'
        @results = Space.where(id: @formula.spaces).paginate(
          page: params[:page], per_page: 30)
        @q = @formula.to_s  # Standardize for re-display
      rescue Formula::ParseError => e
        @error = e
        @results = ThinkingSphinx.search @q
      end
    end
  end
end