
class Value < ActiveRecord::Base
  belongs_to :value_set
  has_many :traits

  def self.true
    @true ||= ValueSet.boolean.values.where(name: 'True').first_or_create!
  end

  def self.false
    @false ||= ValueSet.boolean.values.where(name: 'False').first_or_create!
  end

  def to_s; name; end

  def compliment
    value_set.values.pluck(:id).reject { |v| v == id }
  end

  def ~
    return Value.false if self == Value.true
    return Value.true  if self == Value.false
    Value.find(compliment).first
  end

  def to_i
    return 1 if self == Value.true
    return 0 if self == Value.false
    raise "Not Implemented"
  end
end
