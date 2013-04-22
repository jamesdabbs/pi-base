class Theorem < ActiveRecord::Base
  def name
    to_s
  end
  
  def to_s
    "#{antecedent} ⇒ #{consequent}"
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

  class Examiner < Brubeck::Examiner
    def check
      raise "Found counterexamples: #{@obj.counterexamples}" unless obj.counterexamples.empty?
      true
    end

    def explore
      Space.by_formula(obj.antecedent => true, obj.consequent => nil).each do |s|
        apply obj, s
      end

      Space.by_formula(obj.antecedent => nil,  obj.consequent => false).each do |s|
        apply obj.contrapositive, s
      end
    end

    def apply theorem, space
      puts "Applying #{theorem} to #{space} ..."
      # TODO:
      # - Generate proof trace (traits appearing in antecedent, possibly consequent for disjunctions)
      # - For each trait to be proved, add it with the generated description
    end
  end
end
