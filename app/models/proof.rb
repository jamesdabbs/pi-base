class Proof < ActiveRecord::Base
  belongs_to :trait
  belongs_to :theorem

  validates :trait_id, :theorem_id, presence: true

  has_many :assumptions, dependent: :delete_all
  has_many :traits, through: :assumptions

  def steps
    traits.to_a.insert theorem_index, theorem
  end
end
