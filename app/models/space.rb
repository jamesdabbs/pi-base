class Space < ActiveRecord::Base
  has_paper_trail only: [:name, :description]

  validates :name, :description, presence: true

  has_many :traits, dependent: :destroy

  def self.by_formula fs
    ids = fs.map { |f, val| f.spaces(val) }.inject &:&
    Space.find ids
  end

  def to_s
    name
  end

  def proof_tree
    Proof::Tree.new self
  end
  cache_method :proof_tree

  def available
    ids = traits.pluck :property_id
    Property.where('id NOT IN (?)', ids).pluck :name
  end
end
