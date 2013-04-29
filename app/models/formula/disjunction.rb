class Formula::Disjunction < Formula

  # -- Common formula interface -----

  def spaces where=true
    subs = map { |sf| sf.spaces where }
    # True if any is true
    # False if all are false
    # Nil if any is nil
    where == false ? intersection(subs) : union(subs)
  end

  def ~
    Formula::Conjunction.new *map(&:~)
  end

  def verify space
    # FIXME: memoize this verify call
    witness = find { |sf| sf.verify space }
    witness.nil? ? false : witness.verify(space)
  end

  def force space, traits, theorem, index
    unknown = nil
    each do |sf|
      witnesses = (~sf).verify space
      if witnesses
        traits += witnesses
        index  += witnesses.length
      else
        if unknown
          warn "Unable to force #{self} - too many unknowns"
          return
        else
          unknown = sf
        end
      end
    end
    unknown.force space, traits, theorem, index
  end

  # ----------
  
  def symbol
    '|'
  end
end