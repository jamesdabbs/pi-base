class Formula::Atom < Formula
  def initialize property, value
    # TODO: coerce these between ints, bools & models on demand
    @property = property
    @value    = value
  end

  def to_s
    "#{@property} = #{@value}"
  end

  def subformulae
    self
  end

  def to_atom
    self
  end

  def ~
    # FIXME: handling of value negation for non-booleans
    # FIXME: negating booleans should not require a database hit
    Atom.new @property, Value.find(@value.compliment).first
  end

  def spaces where=true
    if where.nil?
      set = @property.traits.pluck :space_id
      Space.where('id NOT IN (?)', set).pluck :id
    elsif where
      @property.traits.where(value_id: @value.id).pluck :space_id
    else
      @property.traits.where(value_id: @value.compliment).pluck :space_id
    end
  end

  def verify space
    witness = space.traits.where(property: @property, value: @value).first
    witness.nil? ? false : [witness]
  end

  def force space, assumptions
    description = assumptions.flatten.map { |a| "* #{a.assumption_description}" }.join "\n"
    space.traits.create! property: @property, value: @value, description: description
  end

  def self.parse str
    p,v = str.split('=').map &:strip
    property = if p.to_i.zero?
      Property.where(name: p).first!
    else
      Property.find p.to_i
    end
    value = if v.to_i.zero?
      Value.where(name: v).first!
    else
      Value.find v.to_i
    end
    new property, value
  end
end