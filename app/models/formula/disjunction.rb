class Formula::Disjunction < Formula
  def spaces where=true
    subs = subformulae.map { |sf| sf.spaces where }
    # True if any is true
    # False if all are false
    # Nil if any is nil
    where == false ? intersection(subs) : union(subs)
  end

  def to_s
    '(' + subformulae.join(' | ') + ')'
  end
end