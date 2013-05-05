class TheoremsController < ObjectsController
  @object_class = Theorem

  def show
    @traits = @theorem.traits.includes(:space, :property, :value).paginate page: params[:page], per_page: 20
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
