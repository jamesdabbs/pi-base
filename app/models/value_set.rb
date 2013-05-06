class ValueSet < ActiveRecord::Base
  Boolean = where(name: 'Boolean').first_or_create!

  has_many :values

  def to_s
    name
  end
end
