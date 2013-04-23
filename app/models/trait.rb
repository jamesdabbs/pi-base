class Trait < ActiveRecord::Base
  validates :space, :property, :value, :description, presence: true
  validates :property, uniqueness: { scope: :space_id }

  belongs_to :space
  belongs_to :property
  belongs_to :value

  scope :direct,  -> { where deduced: false }
  scope :deduced, -> { where deduced: true  }

  scope :unproven, -> { where description: '' }

  after_create do
    Resque.enqueue TraitExploreJob, id
  end

  def name
    "#{space} - #{property}"
  end

  def to_s
    name
  end

  def assumption_description
    Formula::Atom.new(property, value).to_s
  end

  #-----

  class Examiner
    attr_accessor :trait

    def initialize trait
      @trait = trait
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
end
