class Theorem < ActiveRecord::Base
  def name
    to_s
  end
  
  def to_s
    "#{antecedent} ⇒ #{consequent}"
  end

  def antecedent
    Formula.parse self[:antecedent]
  end

  def consequent
    Formula.parse self[:consequent]
  end
end
