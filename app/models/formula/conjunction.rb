class Formula::Conjunction < Formula

  # -- Common formula interface -----

  def spaces where=true
    subs = map { |sf| sf.spaces where }
    # True if all are true
    # False if any is false
    # Nil if any is nil
    where ? intersection(subs) : union(subs)
  end

  def ~
    Formula::Disjunction.new *subformulae.map(&:~)
  end

  def verify space
    flat_map { |sf| sf.verify(space) or return false }
  end

  def force space, assumptions, theorem, index
    each { |sf| sf.force(space, assumptions, theorem, index) rescue nil }
  end

  # ----------

  def symbol
    '+'
  end
end
