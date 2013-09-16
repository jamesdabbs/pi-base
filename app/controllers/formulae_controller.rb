class FormulaeController < ApplicationController
  def search
    if @q = params[:q]
      @results = begin
        @formula = Formula.load @q.gsub /\&/, '+'
        Space.where(id: @formula.spaces).paginate pagination
      rescue Formula::ParseError => e
        @error = e
        text_search @q, pagination
      end
    end
  end

  private #----------

  def text_search q, opts={}
    Tire::Search::Search.new 'full' do
      query { string q }
      size  opts[:per_page]
      from  opts[:per_page] * (opts[:page] - 1)
    end.results
  end

  def pagination
    { page: params[:page] || 1, per_page: 30 }
  end
end
