class Trait < ActiveRecord::Base
  belongs_to :space
  belongs_to :property
  belongs_to :value

  def name
    "#{space} - #{property}"
  end

  def assumption_description
    Formula::Atom.new(property, value).to_s
  end
end
