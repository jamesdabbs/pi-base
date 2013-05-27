class TheoremsController < ObjectsController
  @object_class = Theorem

  def index
    @theorems = Theorem.paginate page: params[:page], per_page: 15
  end

  def show
    @converse_counters = @theorem.converse.counterexamples
  end

  def related
    traits = @theorem.traits.
      includes(:space, :property, :value).
      sort_by { |t| [t.space.name, t.property.name] }

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
