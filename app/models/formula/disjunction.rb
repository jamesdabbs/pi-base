class Formula::Disjunction < Formula
  @@conj = '|'

  def spaces where=true
    subs = subformulae.map { |sf| sf.spaces where }
    # True if any is true
    # False if all are false
    # Nil if any is nil
    where == false ? intersection(subs) : union(subs)
  end

  def verify space
    [subformulae.find { |sf| sf.verify space }] or raise "Formula did not match"
  end

  def force space, assumptions
    raise "FIXME: Not Implemented"
  end
end