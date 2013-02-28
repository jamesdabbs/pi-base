class Formula::Atom < Formula
  def initialize property, value
    @property = property
    @value    = value
  end

  def to_s
    "#{@property} = #{@value}"
  end

  def spaces where=true
    if where.nil?
      set = @property.traits.pluck :space_id
      Space.where('id NOT IN (?)', set).pluck :id
    elsif where
      @property.traits.where(value: @value).pluck :space_id
    else
      @propery.traits.where(value: @value.compliment).pluck :space_id
    end
  end

  def subformulae
    self
  end
end