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
    witness = subformulae.find { |sf| sf.verify space }
    witness.nil? ? false : [witness]
  end

  def force space, assumptions
    unknown = nil
    subformulae.each do |sf|
      witnesses = (~sf).verify
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