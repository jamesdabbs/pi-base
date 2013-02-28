class Property < ActiveRecord::Base
  has_many :traits
  belongs_to :value_set

  def to_s
    name
  end
end
