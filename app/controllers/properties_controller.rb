class PropertiesController < ObjectsController
  @object_class = Property

  def show
    super
    @theorems = object.theorems.paginate page: params[:theorems],  per_page: 15
  end

  private #-----

  def create_params
    params.require(object_name).permit :name, :description, :value_set_id
  end
end
