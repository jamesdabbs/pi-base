class PropertiesController < ApplicationController
  before_action :set_property, only: [:show, :edit, :update]

  def index
    @properties = Property.paginate page: params[:page], per_page: 30
  end

  def show
    @direct  = @property.traits.direct.paginate  page: params[:direct],  per_page: 15
    @deduced = @property.traits.deduced.paginate page: params[:deduced], per_page: 15
  end

  def new
    @property = Propery.new
    authorize! :manage, @property
  end

  def edit
    authorize! :manage, @property
  end

  def create
    @property = Property.new property_params
    authorize! :manage, @property

    if @property.save
      redirect_to @property, notice: 'Property created'
    else
      render action: 'new'
    end
  end

  def update
    authorize! :manage, @property
    if @property.update property_params
      redirect_to @property, notice: 'Property updated'
    else
      render action: 'edit'
    end
  end

  private #-----

  def set_property
    @property = Property.find params[:id]
  end

  def property_params
    params.require(:property).permit :name, :description
  end
end