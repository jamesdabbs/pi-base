class Formula
  attr_accessor :subformulae

  def initialize subformulae
    @subformulae = subformulae
  end

  def + other
    Formula::Conjunction.new([self, other].inject([]) do |a, f|
      f.is_a?(Formula::Conjunction) ? a + f.subformulae : a + [f]
    end)
  end

  def | other
    Formula::Disjunction.new([self, other].inject([]) do |a, f|
      f.is_a?(Formula::Disjunction) ? a + f.subformulae : a + [f]
    end)
  end

  def self.parse str
  end

  private # ----------

  # TODO: improve using the fact that each array is sorted
  def intersection arrays
    arrays.inject &:&
  end

  def union arrays
    arrays.inject &:|
  end
end