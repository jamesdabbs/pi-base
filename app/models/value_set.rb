class ValueSet < ActiveRecord::Base
  has_many :values

  def self.boolean
    @boolean ||= where(name: 'boolean').first_or_create!
  end

  def to_s; name; end
end
