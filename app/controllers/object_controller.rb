class ObjectController < ApplicationController
  before_action :set_object, only: [:show, :edit, :update, :destroy]

  def index
    self.objects = object_class.paginate page: params[:page], per_page: 30
  end

  def show
    @direct  = object.traits.direct.paginate  page: params[:direct],  per_page: 15
    @deduced = object.traits.deduced.paginate page: params[:deduced], per_page: 15
  end

  def new
    self.object = object_class.new
    authorize! :manage, object
  end

  def edit
    authorize! :manage, object
  end

  def create
    self.object = object_class.new space_params
    authorize! :manage, object

    if object.save
      redirect_to object, notice: "#{object_class.name} created"
    else
      render action: 'new'
    end
  end

  def update
    authorize! :manage, object
    if object.update space_params
      redirect_to object, notice: "#{object_class.name} updated"
    else
      render action: 'edit'
    end
  end

  def destroy
    authorize! :manage, object
    object.destroy
    redirect_to spaces_url, notice: "#{object_class.name} destroyed"
  end

  private #-----

  def object_class
    self.class.instance_variable_get :@object_class
  end

  def object_name
    object_class.name
  end

  def objects= objs
    instance_variable_set :"@#{object_class.model_name.plural}", objs
  end

  def object= obj
    instance_variable_set :"@#{object_class.model_name.singular}", obj
  end

  def object
    instance_variable_get :"@#{object_class.model_name.singular}"
  end

  def set_object
    self.object = object_class.find params[:id]
  end

  def object_params
    params.require(object_name.lower.to_sym).permit :name, :description
  end
end