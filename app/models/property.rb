class Property < ActiveRecord::Base
  has_many :traits
  belongs_to :value_set
end
