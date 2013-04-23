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
    authorize! :manage, @trait
  end

  def edit
    authorize! :manage, @trait
  end

  def create
    attrs = { description: params[:trait][:description] }
    [:space, :property, :value].each do |klass|
      attrs[klass] = klass.to_s.camelize.constantize.where(name: params[:trait][klass]).first!
    end

    @trait = Trait.new attrs
    authorize! :manage, @trait

    if @trait.save
      redirect_to @trait, notice: 'Trait created'
    else
      render action: 'new'
    end
  end

  def update
    authorize! :manage, @trait
    if @trait.update params.require(:trait).permit :description
      redirect_to @trait, notice: 'Trait updated'
    else
      render action: 'edit'
    end
  end

  private #-----

  def set_trait
    @trait = Trait.find params[:id]
  end
end
