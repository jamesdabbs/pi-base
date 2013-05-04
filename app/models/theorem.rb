class Theorem < ActiveRecord::Base
  has_paper_trail only: [:description]

  # ----------

  serialize :antecedent, Formula
  serialize :consequent, Formula
  validates :antecedent, :consequent, :description, presence: true

  # ----------

  has_many :proofs, dependent: :destroy
  has_many :traits, through: :proofs

  # ----------

  has_many :theorem_properties
  has_many :properties, through: :theorem_properties

  def associate_properties!
    [antecedent.atoms, consequent.atoms].flatten.map(&:property).uniq.each do |p|
      TheoremProperty.where(theorem: self, property: p).create!
    end
  end
  after_create :associate_properties!

  # ----------

  scope :unproven, -> { where description: '' }

  def queue_job
    Resque.enqueue TheoremExploreJob, id
  end
  after_create :queue_job
  
  def name &block
    block ||= Proc.new { |atom| atom.pretty_print }
    "#{antecedent.to_s &block} ⇒ #{consequent.to_s &block}"
  end
  
  def to_s
    "#{antecedent} ⇒ #{consequent}"
  end

  def assumption_description
    name
  end
  cache_method :assumption_description

  def contrapositive
    # FIXME: make an explict reason why these can never be saved over the original
    @contrapositive ||= Theorem.new antecedent: ~consequent, consequent: ~antecedent, id: id
  end

  def examples
    @examples ||= Space.by_formula antecedent => true, consequent => true
  end

  def counterexamples
    @counterexamples ||= Space.by_formula antecedent => true, consequent => false
  end

  def apply space
    assumptions = antecedent.verify(space) or return
    consequent.force space, assumptions, self, assumptions.length
  rescue ActiveRecord::RecordInvalid
    # Presumably because it violates the uniqueness constraint, and so already exists
    false
  end

  # -- Exploration tools --

  def candidates
    Space.by_formula antecedent => true, consequent => nil
  end

  def explore
    candidates.each                { |s| apply s }
    contrapositive.candidates.each { |s| contrapositive.apply s }
  end
end
