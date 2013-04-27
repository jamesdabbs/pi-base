class Property < ActiveRecord::Base
  has_paper_trail only: [:name, :description]
  
  validates :name, :description, presence: true

  has_many :traits, dependent: :destroy
  belongs_to :value_set

  has_many :theorem_properties
  has_many :theorems, through: :theorem_properties

  # -- Formula convenience methods -----
  def to_atom
    Formula::Atom.new self, Value::True
  end

  def ~
    ~to_atom
  end

  def + other
    to_atom + other.to_atom
  end

  def | other
    to_atom | other.to_atom
  end
end
