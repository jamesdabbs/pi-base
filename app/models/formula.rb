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
    conj, subs = parse_parens str
    if conj.nil?
      Formula::Atom.parse str
    elsif conj == '+'
      Formula::Conjunction.new(subs.map { |s| parse s })
    elsif conj == '|'
      Formula::Disjunction.new(subs.map { |s| parse s })
    else
      raise "Unrecognized conjunction '#{conj}'"
    end
  end

  private # ----------

  # TODO: improve using the fact that each array is sorted
  def intersection arrays
    arrays.inject &:&
  end

  def union arrays
    arrays.inject &:|
  end

  def self.parse_parens str
    scanner = StringScanner.new str
    result  = scanner.eos? ? Array.new : [""]
    depth   = 0
    conj    = nil

    until scanner.eos?
      if scanner.scan(/[^()\+\|]+/)
        result.last << scanner.matched
      elsif scanner.scan(/\(/)
        result.last << scanner.matched unless depth.zero?
        depth += 1
      elsif scanner.scan(/\)/)
        depth -= 1
        result.last << scanner.matched unless depth.zero?
      elsif scanner.scan(/[\+\|]/)
        if depth.zero?
          conj ||= scanner.matched
          raise "Mismatched conjunction" unless conj == scanner.matched
          result << ""
        else
          result.last << scanner.matched
        end
      end
    end
    [conj, result.map(&:strip)]
  end
end