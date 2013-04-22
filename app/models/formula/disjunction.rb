class Formula::Disjunction < Formula
  @@conj = '|'

  def spaces where=true
    subs = subformulae.map { |sf| sf.spaces where }
    # True if any is true
    # False if all are false
    # Nil if any is nil
    where == false ? intersection(subs) : union(subs)
  end
end