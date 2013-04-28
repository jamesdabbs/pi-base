class Trait < ActiveRecord::Base
  has_paper_trail only: [:description]

  validates :space, :property, :value, presence: true
  validates :property, uniqueness: { scope: :space_id }

  def has_description_if_manually_added
    errors.add(:description, "can't be blank") if !deduced && description.blank?
  end
  validate :has_description_if_manually_added

  belongs_to :space
  belongs_to :property
  belongs_to :value

  has_one :proof

  has_many :proof_traits
  has_many :consequences, through: :proof_traits, source: :proof, class_name: 'Proof'

  scope :direct,  -> { where deduced: false }
  scope :deduced, -> { where deduced: true  }

  scope :unproven, -> { where description: '', proof: nil }

  def find_implied_traits
    Resque.enqueue TraitExploreJob, id
  end
  after_create :find_implied_traits

  def name
    "#{space} - #{property}"
  end

  def to_s
    name
  end

  def assumption_description
    Formula::Atom.new(property, value).pretty_print
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
