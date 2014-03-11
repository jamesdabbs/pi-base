class Trait < ActiveRecord::Base
  has_paper_trail only: [:description]

  # TODO: we should index traits, but there are more than we can fit in our ES plan
  #       can we only index non-deduced ones?

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

  has_one :proof, dependent: :destroy

  has_many :assumptions, dependent: :destroy
  has_many :consequences, through: :assumptions, source: :proof, class_name: 'Proof'

  has_many :supporters, foreign_key: :implied_id
  has_many :supports,   foreign_key: :assumed_id, class_name: 'Supporter'

  scope :direct,  -> { where deduced: false }
  scope :deduced, -> { where deduced: true  }

  scope :unproven, -> { where deduced: false, description: '' }
  def unproven?
    !deduced? && description.blank?
  end

  def find_implied_traits
    PiBase::Application.enqueue TraitExploreJob, id
  end
  after_create :find_implied_traits

  def self.table
    Rails.cache.fetch "/trait-table/#{Trait.maximum :updated_at}", expires_in: 1.day do
      Trait::Table.new.aaData
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

  def as_json opts={}
    super.merge name: opts[:add_space] ? "#{space}: #{name}" : name
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
end
