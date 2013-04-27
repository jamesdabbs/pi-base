class Formula::Conjunction < Formula
  def symbol
    '+'
  end

  def spaces where=true
    subs = subformulae.map { |sf| sf.spaces where }
    # True if all are true
    # False if any is false
    # Nil if any is nil
    where ? intersection(subs) : union(subs)
  end

  def ~
    Formula::Disjunction.new *subformulae.map(&:~)
  end

  def verify space
    subformulae.flat_map { |sf| sf.verify(space) or return false }
  end

  def force space, proof
    subformulae.each { |sf| sf.force space, proof }
  end
end