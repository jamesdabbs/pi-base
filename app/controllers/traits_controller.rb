class TraitsController < ApplicationController
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

  def show
    @trait = Trait.find params[:id]
  end
end
