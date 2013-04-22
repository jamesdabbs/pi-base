class Theorem < ActiveRecord::Base
  def name
    to_s
  end
  
  def to_s
    "#{antecedent} ⇒ #{consequent}"
  end

  def antecedent
    @antecedent ||= Formula.parse self[:antecedent]
  end

  def consequent
    @consequent ||= Formula.parse self[:consequent]
  end

  def examples
    Space.by_formula antecedent => true, consequent => true
  end

  def counterexamples
    Space.by_formula antecedent => true, consequent => false
  end

  class Examiner < Brubeck::Examiner
    def check
      # This should just check counterexamples.empty?, but what should we do if it isn't?
      raise "FIXME: add checking logic"
    end

    def explore
      direct = Space.by_formula @obj.antecedent => true, @obj.consequent => nil
      contra = Space.by_formula @obj.antecedent => nil,  @obj.consequent => false
      puts "Exploring #{@obj}"
      puts "  Direct: #{direct.map &:name}"
      puts "  Contra: #{contra.map &:name}"
      raise "FIXME: add proofs" unless direct.empty? && contra.empty?
    end
  end
end
