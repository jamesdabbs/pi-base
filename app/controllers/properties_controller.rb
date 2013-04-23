class PropertiesController < ApplicationController
  before_action :set_property, only: [:show, :edit, :update]

  def index
    @properties = Property.paginate page: params[:page], per_page: 30
  end

  def show
    @traits = @property.traits.paginate page: params[:page], per_page: 30
  end

  def new
    @property = Propery.new
  end

  def edit
  end

  def create
    @property = Property.new property_params

    if @property.save
      redirect_to @property, notice: 'Property created'
    else
      render action: 'new'
    end
  end

  def update
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