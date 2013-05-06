class Value < ActiveRecord::Base
  # These are so ubiquitous that we'll prefetch and store them
  True  = ValueSet::Boolean.values.where(name: 'True' ).first_or_create!
  False = ValueSet::Boolean.values.where(name: 'False').first_or_create!

  belongs_to :value_set
  has_many :traits

  def to_s
    name
  end

  def compliment
    value_set.values.pluck(:id).reject { |v| v == id }
  end

  def ~
    return False if self == True
    return True  if self == False
    Value.find(compliment).first
  end
end
