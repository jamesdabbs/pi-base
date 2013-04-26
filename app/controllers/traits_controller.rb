class TraitsController < ApplicationController
  before_action :set_trait, only: [:show, :edit, :update]

  def index
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
  end

  def new
    @trait = Trait.new
    authorize! :create, @trait
  end

  def edit
    authorize! :edit, @trait
  end

  def create
    @trait = Trait.new trait_params
    authorize! :create, @trait
    
    [:space, :property, :value].each do |klass|
      object = klass.to_s.camelize.constantize.where(name: params[:trait][klass]).first!
      @trait.send "#{klass}=", object
    end

    if @trait.save
      redirect_to @trait, notice: 'Trait created'
    else
      render action: 'new'
    end
  end

  def update
    authorize! :edit, @trait
    if @trait.update trait_params
      redirect_to @trait, notice: 'Trait updated'
    else
      render action: 'edit'
    end
  end

  private #-----

  def set_trait
    @trait = Trait.find params[:id]
  end

  def trait_params
    params.require(:trait).permit :description
  end
end
