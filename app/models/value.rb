class Value < ActiveRecord::Base
  belongs_to :value_set
  has_many :traits

  def to_s
    name
  end

  def compliment
    value_set.values.pluck(:id).reject { |v| v == id }
  end
end
