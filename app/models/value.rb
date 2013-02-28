class Value < ActiveRecord::Base
  belongs_to :value_set
  has_many :traits

  def to_s
    name
  end
end
