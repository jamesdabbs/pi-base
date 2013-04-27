class Value < ActiveRecord::Base
  belongs_to :value_set
  has_many :traits

  def compliment
    value_set.values.pluck(:id).reject { |v| v == id }
  end
end
