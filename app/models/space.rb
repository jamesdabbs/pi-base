class Space < ActiveRecord::Base
  has_many :traits

  def self.by_formula fs
    ids = fs.map { |f, val| f.spaces(val) }.inject &:&
    Space.find ids
  end

  def to_s
    name
  end
end
