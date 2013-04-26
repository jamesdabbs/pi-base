class PropertiesController < ObjectsController
  @object_class = Property

  def show
    super
    @theorems = object.theorems.paginate page: params[:theorems],  per_page: 15
  end
end
