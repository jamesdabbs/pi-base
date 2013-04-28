class TheoremsController < ApplicationController
  before_action :set_theorem, only: [:show, :edit, :update]

  def index
    @theorems = Theorem.paginate page: params[:page], per_page: 30
  end

  def show
    @traits = @theorem.traits.paginate page: params[:page], per_page: 20
  end

  def new
    @theorem = Theorem.new
    authorize! :create, @theorem
  end

  def edit
    authorize! :edit, @theorem
  end

  def create
    @theorem = Theorem.new params.require(:theorem).permit :description, :antecedent, :consequent
    authorize! :create, @theorem

    if @theorem.save
      redirect_to @theorem, notice: 'Theorem created'
    else
      render action: 'new'
    end
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
