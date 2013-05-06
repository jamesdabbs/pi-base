class Value < ActiveRecord::Base
  belongs_to :value_set
  has_many :traits

  def self.true
    @true ||= where(name: 'True' ).first
  end

  def self.false
    @false ||= where(name: 'False').first
  end

  def to_s
    name
  end

  def compliment
    value_set.values.pluck(:id).reject { |v| v == id }
  end

  def ~
    return Value.false if self == Value.true
    return Value.true  if self == Value.false
    Value.find(compliment).first
  end
end
