class Property < ActiveRecord::Base
  has_many :traits
  belongs_to :value_set

  include Wiki

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
