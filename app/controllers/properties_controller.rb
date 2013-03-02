class PropertiesController < ApplicationController
  def index
    @properties = Property.paginate page: params[:page], per_page: 30
  end

  def show
    @property = Property.find params[:id]
    @traits   = @property.traits.paginate page: params[:page], per_page: 30
  end
end