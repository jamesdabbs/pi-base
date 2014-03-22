class FormulaeController < ApplicationController
  def search
    if @q = params[:q]
      begin
        @formula = Formula.parse_text @q
        @results = Space.where(id: @formula.spaces).paginate(
          page: params[:page], per_page: 30)
      rescue Formula::ParseError => e
        @error = e
        @results = Search.query(@q).paginate(
          page: params[:page], per_page: 30)
      end
    end
  end
end
