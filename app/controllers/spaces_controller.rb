class SpacesController < ApplicationController
  before_action :set_space, only: [:show, :edit, :update]

  def index
    @spaces = Space.paginate page: params[:page], per_page: 30
  end

  def show
    @traits = @space.traits.paginate page: params[:page], per_page: 30
  end

  def new
    @space = Space.new
  end

  def edit
  end

  def create
    @space = Space.new space_params

    if @space.save
      redirect_to @space, notice: 'Space created'
    else
      render action: 'new'
    end
  end

  def update
    if @space.update space_params
      redirect_to @space, notice: 'Space updated'
    else
      render action: 'edit'
    end
  end

  private #-----

  def set_space
    @space = Space.find params[:id]
  end

  def space_params
    params.require(:space).permit :name, :description
  end
end
