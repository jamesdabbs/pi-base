class TraitsController < ObjectsController
  @object_class = Trait

  def index
    # FIXME: serve as JSON and cache
    @spaces     = Space.order 'id ASC'
    @properties = Property.order 'id ASC'

    values = {}
    Value.all.each { |v| values[v.id] = v.name.sub('True', '+').sub('False', '-') }

    @traits = Hash[ @spaces.map { |s| [s.id,{}] } ]
    Trait.select(:id, :space_id, :property_id, :value_id).each do |t|
      @traits[t.space_id][t.property_id] ||= [t.id, values[t.value_id]]
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
