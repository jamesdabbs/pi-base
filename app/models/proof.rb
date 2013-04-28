class Proof < ActiveRecord::Base
  belongs_to :trait
  belongs_to :theorem

  has_many :proof_traits, dependent: :delete_all
  has_many :traits, through: :proof_traits

  # FIXME: on delete, invalidate and recheck trait which this proves

  def steps
    traits.to_a.insert theorem_index, theorem
  end
end
