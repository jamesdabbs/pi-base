class Trait < ActiveRecord::Base
  has_paper_trail only: [:description]

  validates :space, :property, :value, :description, presence: true
  validates :property, uniqueness: { scope: :space_id }

  serialize :proof, Proof

  belongs_to :space
  belongs_to :property
  belongs_to :value

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
    trait.property.theorems.each do |theorem|
      if theorem.antecedent.verify trait.space
        theorem.apply trait.space
      elsif (~theorem.consequent).verify trait.space
        theorem.contrapositive.apply trait.space
      end
    end
  end
end
