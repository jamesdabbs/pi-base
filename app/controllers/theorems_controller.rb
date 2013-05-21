class TheoremsController < ObjectsController
  @object_class = Theorem

  def show
  end

  def related
    traits = @theorem.traits.includes :space, :property, :value
    render json: { "Implied" => traits }.as_json(add_space: true)
  end

  private #-----

  def create_params
    params.require(:theorem).permit :description, :antecedent, :consequent
  end

  def set_object
    super
    @theorem = TheoremDecorator.new @theorem
  end
end
