class TraitsController < ApplicationController
  before_action :set_trait, only: [:show, :edit, :update]

  def index
    @spaces     = Space.order('id ASC').pluck :id
    @properties = Property.order('id ASC').pluck :id

    values = {}
    Value.all.each { |v| values[v.id] = v.name.sub('True', '+').sub('False', '-') }

    @traits = Hash[ @spaces.map { |s| [s,{}] } ]
    Trait.select(:id, :space_id, :property_id, :value_id).each do |t|
      @traits[t.space_id][t.property_id] ||= [t.id, values[t.value_id]]
    end
  end

  def new
    @trait = Trait.new
    authorize! :manage, @trait
  end

  def edit
    authorize! :manage, @trait
  end

  def create
    @trait = Trait.new trait_params
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

  def trait_params
    param.require(:trait).permit :space_id, :property_id, :value_id, :description
  end
end
