class Formula::Conjunction < Formula
  def spaces where=true
    subs = subformulae.map { |sf| sf.spaces where }
    # True if all are true
    # False if any is false
    # Nil if any is nil
    where ? intersection(subs) : union(subs)
  end

  def to_s
    '(' + subformulae.join(' + ') + ')'
  end
end