class Property < ActiveRecord::Base
  validates :name, :description, presence: true

  has_many :traits
  belongs_to :value_set

  has_many :theorem_properties
  has_many :theorems, through: :theorem_properties

  def self.choices
    Property.all.map { |s| [s.name, s.id] }
  end

  def to_s
    name
  end

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
