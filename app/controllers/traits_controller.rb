class TraitsController < ObjectsController
  @object_class = Trait

  def index
    respond_to do |format|
      format.html
      format.json { render json: Trait.table }
    end
  end

  def show
    # Traits don't have direct / deduced related
  end

  def available
    specified = lookup(:space) || lookup(:property)
    render json: specified ? specified.available : []
  end

  private #-----

  def lookup klass
    klass.to_s.camelize.constantize.where(name: params[:trait][klass]).first
  end

  def create_params
    {
      space:       lookup(:space),
      property:    lookup(:property),
      value:       lookup(:value),
      description: params[:trait][:description]
    }
  end
end
