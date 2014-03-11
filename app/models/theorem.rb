class Theorem < ActiveRecord::Base
  has_paper_trail only: [:description]

  include Search

  # ----------

  serialize :antecedent, Formula
  serialize :consequent, Formula

  validates :antecedent, :consequent, :description, presence: true

  def formulae_are_valid
    [:antecedent, :consequent].each do |f|
      begin
        Formula.load send f
      rescue => e
        errors.add f, "could not be parsed as a formula: #{e}"
      end
    end
  end
  validate :formulae_are_valid

  def has_no_counterexamples
    unless counterexamples.empty?
      errors.add :consequent, "has a counterexample: #{counterexamples.first}"
    end
  rescue Formula::ParseError => e
    # Will be handled by another validation
  end
  validate :has_no_counterexamples

  # ----------

  has_many :proofs, dependent: :destroy
  has_many :traits, through: :proofs

  # ----------

  has_many :theorem_properties, dependent: :destroy
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
    PiBase::Application.enqueue TheoremExploreJob, id
  end
  after_create :queue_job

  # ----------

  def name
    "#{antecedent} ⇒ #{consequent}"
  end
  cache_method :name

  def to_s
    name
  end

  # ----------

  def contrapositive
    # FIXME: make an explict reason why these can never be saved over the original
    @contrapositive ||= ((~consequent) >> ~antecedent).tap { |t| t.id = id }
  end

  def converse
    @converse ||= consequent >> antecedent
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
