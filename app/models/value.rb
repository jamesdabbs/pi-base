class Value < ActiveRecord::Base
  belongs_to :value_set
  has_many :traits
end
