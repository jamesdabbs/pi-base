class PropertiesController < ObjectsController
  @object_class = Property

  def show
    super
    @theorems = object.theorems.paginate page: params[:theorems],  per_page: 15
  end

  def related
    deduced, direct = @property.traits.
      includes(:space, :property, :value).
      sort_by { |t| t.space.name }.
      partition { |t| t.deduced? }

    render json: {
      "Manually Added"          => direct,
      "Automatically Generated" => deduced,
      "Needing Proofs"          => direct.select(&:unproven?)
    }.as_json(add_space: true)
  end

  private #-----

  def create_params
    params.require(object_name).permit :name, :description, :value_set_id
  end
end
