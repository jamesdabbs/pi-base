class TheoremsController < ApplicationController
  before_action :set_theorem, only: [:show, :edit, :update]

  def index
    @theorems = Theorem.paginate page: params[:page], per_page: 30
  end

  def show
  end

  def edit
    authorize! :edit, @theorem
  end

  def update
    authorize! :edit, @theorem
    if @theorem.update params.require(:theorem).permit :description
      redirect_to @theorem, notice: 'Theorem updated'
    else
      render action: 'edit'
    end
  end

  private #-----

  def set_theorem
    @theorem = Theorem.find params[:id]
  end    
end
