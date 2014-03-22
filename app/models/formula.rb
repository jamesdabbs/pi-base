class Formula
  class ParseError < StandardError
  end

  include Enumerable

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

  def >> other
    Theorem.new antecedent: self, consequent: other
  end

  def each &block
    subformulae.each(&block)
  end

  def self.parse_text q
    q.gsub! /\&/, '+'
    p = Parser.new q
    f = if p.conjunction.nil?
      Atom.parse_text q
    else
      p.subformulae.map { |s| parse_text s }.inject &p.conjunction.to_sym
    end
    p.negated? ? ~f : f
  end

  # -- Common formula interface -----

  def self.load str
    return str if str.nil? || str.is_a?(Formula)
    d = str.is_a?(Hash) ? str : JSON.parse(str)
    case d.delete("_type").to_sym
    when :atom
      Atom.new Property.find(d["property"]), Value.find(d["value"])
    when :conjunction
      Conjunction.new *d["subformulae"].map { |f| self.load f }
    when :disjunction
      Disjunction.new *d["subformulae"].map { |f| self.load f }
    else
      raise Error, "Unrecognized type: #{type}"
    end
  end

  def self.dump formula
    formula.to_json
  end

  def to_s &block
    '(' + map { |s| s.to_s(&block) }.join(" #{symbol} ") + ')'
  end

  def atoms
    map(&:atoms).flatten
  end

  # ----------

  def flatten
    self.class.new(*inject([]) do |fs, f|
      if f.class == self.class
        fs += f.subformulae
      else
        fs << f
      end
    end)
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
    Parser.new(str).process
  end
end
