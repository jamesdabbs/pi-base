class Formula
  attr_accessor :subformulae

  def initialize subformulae
    @subformulae = subformulae
  end

  def + other
    subs = [self.subformulae, other.subformulae]
    subs.flatten! if other.is_a? Formula::Conjunction
    Formula::Conjunction.new subs
  end

  def | other
    subs = [self.subformulae, other.subformulae]
    subs.flatten! if other.is_a? Formula::Disjunction
    Formula::Disjunction.new subs
  end

  private # ----------

  # TODO: improve using the fact that each array is sorted
  def intersection *arrays
    arrays.inject &:&
  end

  def union *arrays
    arrays.inject &:|
  end
end