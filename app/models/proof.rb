class Proof
  attr_accessor :assumptions

  def self.load str
    # FIXME: this need not make more than 2 queries
    return nil if str.nil?
    assumptions = str.split(',').map do |a|
      klass, id = a.split ' '
      klass.constantize.find id
    end
    new assumptions
  end

  def self.dump proof
    proof.assumptions.map { |a| "#{a.class.name} #{a.id}" }.join ','
  end

  def initialize assumptions
    @assumptions = assumptions
  end

  def steps
    @assumptions.map { |a| a.assumption_description }
  end
end