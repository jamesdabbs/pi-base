class Space < ActiveRecord::Base
  has_many :traits

  include Wiki

  def to_s
    name
  end
end
