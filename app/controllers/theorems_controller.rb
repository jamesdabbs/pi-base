class TheoremsController < ApplicationController
  def index
    @theorems = Theorem.paginate page: params[:page], per_page: 30
  end

  def show
    @theorem = Theorem.find params[:id]
  end
end
