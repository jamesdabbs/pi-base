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
      @property.traits.where(value_id: @value.id).pluck :space_id
    else
      @property.traits.where(value_id: @value.compliment).pluck :space_id
    end
  end

  def subformulae
    self
  end

  def self.parse str
    if str.include? '='
      new *str.split('=')
    elsif str.start_with? '~'
      new str, false
    else
      new str, true
    end
  end
end