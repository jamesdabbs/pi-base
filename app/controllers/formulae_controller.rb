class FormulaeController < ApplicationController
  def search
    if @q = params[:q]
      r = begin
        @formula = Formula.load @q.gsub /\&/, '+'
        Space.where id: @formula.spaces
      rescue Formula::ParseError => e
        @error = e
        @results = Space.all # FIXME: full text search
      end
      @results &&= @results.paginate page: params[:page], per_page: 30
    end
  end
end
