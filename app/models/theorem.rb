class Theorem < ActiveRecord::Base
  serialize :formula, Formula

  def name
    to_s
  end
  
  def to_s
    "#{antecedent} ⇒ #{consequent}"
  end
end
