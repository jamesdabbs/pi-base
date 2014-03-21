class Formula::Disjunction < Formula

  # -- Common formula interface -----

  def == other
    self.class == other.class && subformulae.sort == other.subformulae.sort
  end

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

  def force space, assumptions, theorem, index
    unknown = nil
    map do |sf|
      witnesses = (~sf).verify space
      if witnesses
        assumptions += witnesses
        index  += witnesses.length
      else
        if unknown
          Rails.logger.info "Unable to force #{self} - too many unknowns"
          return
        else
          unknown = sf
        end
      end
    end
    unknown.force space, assumptions, theorem, index
  end

  def as_json opts={}
    { _type: :disjunction, subformulae: subformulae.map(&:as_json) }
  end

  # ----------

  def symbol
    '|'
  end
end
