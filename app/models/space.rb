class Space < ActiveRecord::Base
  has_paper_trail only: [:name, :description]

  validates :name, :description, presence: true

  has_many :traits

  def self.choices
    Space.all.map { |s| [s.name, s.id] }
  end

  def self.by_formula fs
    ids = fs.map { |f, val| f.spaces(val) }.inject &:&
    Space.find ids
  end

  def to_s
    name
  end
end
