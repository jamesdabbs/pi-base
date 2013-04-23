class SpacesController < ApplicationController
  before_action :set_space, only: [:show, :edit, :update]

  def index
    @spaces = Space.paginate page: params[:page], per_page: 30
  end

  def show
    @direct  = @space.traits.direct.paginate  page: params[:direct],  per_page: 15
    @deduced = @space.traits.deduced.paginate page: params[:deduced], per_page: 15
  end

  def new
    @space = Space.new
    authorize! :manage, @space
  end

  def edit
    authorize! :manage, @space
  end

  def create
    @space = Space.new space_params
    authorize! :manage, @space

    if @space.save
      redirect_to @space, notice: 'Space created'
    else
      render action: 'new'
    end
  end

  def update
    authorize! :manage, @space
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
