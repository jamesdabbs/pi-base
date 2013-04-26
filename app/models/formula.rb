class Formula
  class ParseError < StandardError
  end

  attr_accessor :subformulae

  def initialize *subformulae
    @subformulae = subformulae
  end

  def + other
    Formula::Conjunction.new(self, other).flatten
  end
  alias_method :&, :+

  def | other
    Formula::Disjunction.new(self, other).flatten
  end

  def flatten
    self.class.new(*subformulae.inject([]) do |fs, f|
      if f.class == self.class
        fs += f.subformulae
      else
        fs << f.subformulae
      end
    end)
  end

  def to_s &block
    '(' + subformulae.map { |s| s.to_s(&block) }.join(" #{symbol} ") + ')'
  end

  def atoms
    subformulae.map(&:atoms).flatten
  end

  def self.parse str
    return str if str.is_a? Formula
    conj, subs = parse_parens str
    if conj.nil?
      Formula::Atom.parse str
    else
      subs.map { |s| parse s }.inject &conj.to_sym
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
    stripped = str =~ /^\((.*[\+\|].*)\)$/ ? $1 : str
    scanner  = StringScanner.new stripped
    result   = scanner.eos? ? Array.new : [""]
    depth    = 0
    conj     = nil

    until scanner.eos?
      if scanner.scan(/\\/)
        result.last << scanner.matched
        scanner.scan(/./)
        result.last << scanner.matched
      elsif scanner.scan(/[^()\+\|\\]+/)
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