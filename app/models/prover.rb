class Prover
  def self.from theorem
    direct = theorem.antecedent.spaces(true) & theorem.consequent.spaces(nil)
    contrapositive = theorem.antecedent.spaces(nil) & theorem.consequent.spaces(false)
    Space.find (direct + contrapositive).uniq
  end

  def self.check theorem
    # FIXME: implement as background job
  end
end