class Property < ActiveRecord::Base
  has_paper_trail only: [:name, :description]
  
  validates :name, :description, :value_set, presence: true

  has_many :traits, dependent: :destroy
  belongs_to :value_set

  has_many :theorem_properties
  has_many :theorems, through: :theorem_properties

  serialize :meta, JSON

  include Tire::Model::Search
  include Tire::Model::Callbacks

  def to_indexed_json
    h = as_json
    h.merge(h.delete 'meta').to_json
  end

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
