class Space < ActiveRecord::Base
  has_paper_trail only: [:name, :description]

  validates :name, :description, presence: true

  has_many :traits, dependent: :destroy

  def self.by_formula fs
    ids = fs.map { |f, val| f.spaces(val) }.inject &:&
    Space.find ids
  end
end
