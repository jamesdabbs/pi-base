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
    ids = antecedent.spaces(true) & consequent.spaces(true)
    Space.find ids
  end

  def counterexamples
    ids = antecedent.spaces(true) & consequent.spaces(false)
    Space.find ids
  end
end
