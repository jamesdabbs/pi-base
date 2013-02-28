class Atom
  def initialize property, value
    @property = property
    @value    = value
  end

  def to_s
    "#{@property} = #{@value}"
  end

  def spaces where=true
    if where.nil?
      set = Trait.where(property_id: @property.id).uniq.pluck :space_id
      Space.includes(:traits).where 'id NOT IN (?)', set
    else
      Space.includes(:traits).where traits: {
        property_id: @property.id,
        value_id:    where ? @value.id : compliment
      }
    end
  end

  private # ----------

  def compliment
    @value.value_set.values.select { |w| w != @value }.map &:id
  end
end