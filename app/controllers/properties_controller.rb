class PropertiesController < ObjectsController
  @object_class = Property

  def show
    super
    @theorems = object.theorems.paginate page: params[:theorems],  per_page: 15
  end

  def related
    traits = @property.traits.includes :space, :property, :value
    render json: {
      "Manually Added"          => traits.direct,
      "Automatically Generated" => traits.deduced,
      "Needing Proofs"          => traits.unproven
    }.as_json(add_space: true)
  end

  private #-----

  def create_params
    params.require(object_name).permit :name, :description, :value_set_id
  end
end
