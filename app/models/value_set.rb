class ValueSet < ActiveRecord::Base
  has_many :values

  def self.boolean
    @boolean ||= where(name: 'Boolean').first
  end

  def to_s
    name
  end
end
