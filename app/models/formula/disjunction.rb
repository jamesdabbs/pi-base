class Formula::Disjunction < Formula
  def symbol
    '|'
  end

  def spaces where=true
    subs = subformulae.map { |sf| sf.spaces where }
    # True if any is true
    # False if all are false
    # Nil if any is nil
    where == false ? intersection(subs) : union(subs)
  end

  def ~
    Formula::Conjunction.new *subformulae.map(&:~)
  end

  def verify space
    # FIXME: memoize this verify call
    witness = subformulae.find { |sf| sf.verify space }
    witness.nil? ? false : [witness.verify(space)]
  end

  def force space, assumptions
    unknown = nil
    subformulae.each do |sf|
      witnesses = (~sf).verify space
      if witnesses
        assumptions += witnesses
      else
        if unknown
          warn "Unable to force #{self} - too many unknowns"
          return
        else
          unknown = sf
        end
      end
    end
    unknown.force space, assumptions
  end
end