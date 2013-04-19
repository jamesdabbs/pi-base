class Formula::Atom < Formula
  def initialize property, value
    # TODO: coerce these between ints, bools & models on demand
    @property = property
    @value    = value
  end

  def to_s
    "#{@property} = #{@value}"
  end

  def to_atom
    self
  end

  def ~
    # FIXME: handling of value negation
    Atom.new @property, !@value
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

  def subformulae
    self
  end

  def self.parse str
    p,v = str.split('=').map &:strip
    property = if p =~ /\d+/
      Property.find p.to_i
    else
      Property.where(name: p).first!
    end
    value = if v =~ /\d+/
      Value.find v.to_i
    else
      Value.where(name: v).first!
    end
    new property, value
  end
end