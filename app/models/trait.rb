class Trait < ActiveRecord::Base
  validates :space, :property, :value, :description, presence: true

  belongs_to :space
  belongs_to :property
  belongs_to :value

  scope :direct,  -> { where deduced: false }
  scope :deduced, -> { where deduced: true  }

  def name
    "#{space} - #{property}"
  end

  def assumption_description
    Formula::Atom.new(property, value).to_s
  end
end
