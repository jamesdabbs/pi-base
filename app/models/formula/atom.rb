class Formula::Atom < Formula
  attr_reader :property, :value

  def initialize property, value, negated=false
    # TODO: coerce these between ints, bools & models on demand
    @property    = property
    @value       = negated ? ~value : value
  end

  # -- Common formula interface -----

  def self.load str
    negated  = str =~ /~\s*/
    p,v      = str.gsub(/~\s*/, '').split('=').map &:strip
    property = Atom.parse_name_or_id p, Property
    value    = Atom.parse_name_or_id v, Value, Value.true
    new property, value, negated
  end

  def self.dump atom
    "#{atom.property.name} = #{atom.value.name}"
  end

  def to_s &block
    block ? block.call(self) : name
  end

  def spaces where=true
    if where.nil?
      set = @property.traits.pluck :space_id
      spaces = set.empty? ? Space : Space.where('id NOT IN (?)', set)
      spaces.pluck :id
    elsif where
      @property.traits.where(value_id: @value.id).pluck :space_id
    else
      @property.traits.where(value_id: @value.compliment).pluck :space_id
    end
  end

  def ~
    Atom.new @property, ~@value
  end

  def verify space
    witness = space.traits.where(property: @property, value: @value).first
    witness.nil? ? false : [witness]
  end

  def force space, assumptions, theorem, index
    trait = space.traits.create! property: @property, value: @value, deduced: true
    proof = Proof.create! trait: trait, theorem: theorem, theorem_index: index
    assumptions.each do |assumption| 
      proof.assumptions.create! trait: assumption
      if assumption.supporters.empty?
        trait.supporters.create! assumed_id: assumption.id
      else
        assumption.supporters.each do |supporter|
          trait.supporters.create! assumed_id: supporter.assumed_id
        end
      end
    end
    trait
  end

  def atoms
    [self]
  end

  def as_json opts={}
    { property: @property, value: @value }
  end

  private # ----------

  def name
    case value
    when Value.true
      property.name
    when Value.false
      "¬ #{property.name}"
    else
      "#{property.name} = #{value.name}"
    end
  end

  def self.parse_name_or_id str, klass, default=nil
    return default if !str.present? && default
    str.to_i.zero? ? klass.where(name: str).first! : klass.find(str.to_i)
  rescue ActiveRecord::RecordNotFound => e
    raise ParseError.new "Unrecognized #{klass}: #{str}"
  end
end
