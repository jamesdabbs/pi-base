class Theorem < ActiveRecord::Base
  validates :antecedent, :consequent, :description, presence: true

  scope :unproven, -> { where description: '' }

  after_create do
    Resque.enqueue TheoremExploreJob, self.id
  end

  def name
    to_s
  end
  
  def to_s
    "#{antecedent} ⇒ #{consequent}"
  end

  def assumption_description
    to_s
  end

  # FIXME: use Rails serialization for 
  def antecedent
    @antecedent ||= Formula.parse self[:antecedent]
  end

  def consequent
    @consequent ||= Formula.parse self[:consequent]
  end

  def contrapositive
    @contrapositive ||= begin
      c = Theorem.new
      c.antecedent = ~consequent
      c.consequent = ~antecedent
      c
    end
  end

  def examples
    @examples ||= Space.by_formula antecedent => true, consequent => true
  end

  def counterexamples
    @counterexamples ||= Space.by_formula antecedent => true, consequent => false
  end

  def apply space
    assumptions = antecedent.verify space
    assumptions << self
    consequent.force space, assumptions
  end

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
