class Theorem < ActiveRecord::Base
  has_paper_trail only: [:description]

  # ----------

  serialize :antecedent, Formula
  serialize :consequent, Formula
  validates :antecedent, :consequent, :description, presence: true

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
    to_s
  end

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
    consequent.force space, Proof.new(assumptions << self)
  rescue ActiveRecord::RecordInvalid
    # Presumably because it violates the uniqueness constraint, and so already exists
    false
  end

  def explore
    TheoremExploreJob.perform id
  end

  #-----

  class Examiner
    attr_accessor :theorem

    def initialize theorem
      @theorem = theorem
    end

    def check
      raise "Found counterexamples: #{theorem.counterexamples}" unless theorem.counterexamples.empty?
      true
    end

    def explore
      Space.by_formula(theorem.antecedent => true, theorem.consequent => nil).each do |s|
        theorem.apply s
      end

      Space.by_formula(theorem.antecedent => nil,  theorem.consequent => false).each do |s|
        theorem.contrapositive.apply s
      end
    end
  end
end
