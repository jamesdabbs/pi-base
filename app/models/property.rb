class Property < ActiveRecord::Base
  has_paper_trail only: [:name, :description]
  
  validates :name, :description, :value_set, presence: true

  has_many :traits, dependent: :destroy
  belongs_to :value_set

  has_many :theorem_properties
  has_many :theorems, through: :theorem_properties

  include SearchObject

  def to_s
    name
  end

  def available
    ids = traits.pluck :space_id
    Space.where('id NOT IN (?)', ids).pluck :name
  end

  # -- Formula convenience methods -----
  def atom value=Value.true
    Formula::Atom.new self, value
  end

  def ~
    ~atom
  end

  def + other
    atom + other.atom
  end

  def | other
    atom | other.atom
  end
end
