class Trait < ActiveRecord::Base
  belongs_to :space
  belongs_to :property
  belongs_to :value

  def name
    "#{space} - #{property}"
  end
end
