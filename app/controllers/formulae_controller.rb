class FormulaeController < ApplicationController
  def search
    if @q = params[:q]
      @results = begin
        @formula = Formula.load @q.gsub /\&/, '+'
        Space.where(id: @formula.spaces).paginate pagination
      rescue Formula::ParseError => e
        @error = e
        text_search @q
      end
    end
  end

  private #----------

  def text_search q
    # FIXME: pagination
    Tire::Search::Search.new 'full' do
      query { string q }
      size  30
    end.results
  end

  def pagination
    { page: params[:page], per_page: 30 }
  end
end
