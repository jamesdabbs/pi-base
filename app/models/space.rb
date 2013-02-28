class Space < ActiveRecord::Base
  has_many :traits

  def to_s
    name
  end
end
