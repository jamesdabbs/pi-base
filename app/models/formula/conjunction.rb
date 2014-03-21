class Formula::Conjunction < Formula

  # -- Common formula interface -----

  def == other
    self.class == other.class && subformulae.sort == other.subformulae.sort
  end

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
    map { |sf| sf.force(space, assumptions, theorem, index) rescue nil }
  end

  def as_json opts={}
    { _type: :conjunction, subformulae: subformulae.map(&:as_json) }
  end

  # ----------

  def symbol
    '+'
  end
end
