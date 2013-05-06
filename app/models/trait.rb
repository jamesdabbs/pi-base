class Trait < ActiveRecord::Base
  has_paper_trail only: [:description]

  # ----------

  validates :space, :property, :value, presence: true
  validates :property, uniqueness: { scope: :space_id }

  def has_description_if_manually_added
    errors.add(:description, "can't be blank") if !deduced && description.blank?
  end
  validate :has_description_if_manually_added

  def value_is_in_value_set
    unless value.value_set_id == property.value_set_id
      errors.add :value, "must be in #{property.value_set}"
    end
  end
  validate :value_is_in_value_set

  # ----------

  belongs_to :space, touch: true
  belongs_to :property
  belongs_to :value

  has_one :proof

  has_many :assumptions
  has_many :consequences, through: :assumptions, source: :proof, class_name: 'Proof'

  has_many :supporters, foreign_key: :implied_id
  has_many :supports,   foreign_key: :assumed_id, class_name: 'Supporter'

  scope :direct,  -> { where deduced: false }
  scope :deduced, -> { where deduced: true  }

  scope :unproven, -> { where deduced: false, description: '' }

  def find_implied_traits
    Brubeck::Application.enqueue TraitExploreJob, id
  end
  after_create :find_implied_traits

  def self.table
    Rails.cache.fetch "/trait-table/#{Trait.maximum :updated_at}", expires_in: 1.day do
      spaces     = Space.all.select    :id, :name
      properties = Property.all.select :id, :name

      values = {}
      Value.all.each { |v| values[v.id] = v.name.sub('True', '+').sub('False', '-') }

      traits = Hash[ spaces.map { |s| [s.id,{}] } ]
      select(:id, :space_id, :property_id, :value_id).each do |t|
        traits[t.space_id][t.property_id] ||= [t.id, values[t.value_id]]
      end
      {
        spaces:     spaces,
        properties: properties,
        traits:     traits
      }.to_json
    end
  end

  # ----------

  def name
    atom.to_s
  end
  cache_method :name

  def to_s
    name
  end

  # ----------

  def atom
    @atom ||= Formula::Atom.new property, value
  end

  def explore
    property.theorems.each do |theorem|
      if theorem.antecedent.verify space
        theorem.apply space
      elsif (~theorem.consequent).verify space
        theorem.contrapositive.apply space
      end
    end
  end

  def destroy
    raise # FIXME: implement destroy
  end
end
