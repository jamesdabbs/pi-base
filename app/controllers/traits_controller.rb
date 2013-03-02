class TraitsController < ApplicationController
  def index
    @traits = Trait.paginate page: params[:page], per_page: 100
  end

  def show
    @trait = Trait.find params[:id]
  end
end
