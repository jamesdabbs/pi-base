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
  alias_method :&, :+

  def | other
    Formula::Disjunction.new([self, other].inject([]) do |a, f|
      f.is_a?(Formula::Disjunction) ? a + f.subformulae : a + [f]
    end)
  end

  def self.parse str
    conj, subs = parse_parens str
    if conj.nil?
      Formula::Atom.parse str
    else
      subs.map { |s| parse s }.inject &conj.to_sym
    end
  end

  def self.import str
    # For importing strings from the old-style format
    if str[0] == '('
      conj = str[1]
      str[2..-2].split(',').map { |s| import s }.inject &conj.to_sym
    else
      Formula::Atom.parse str
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