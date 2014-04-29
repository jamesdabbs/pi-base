require "spec_helper"

describe "Automatic deduction", :job do
  before :all do
    @p = create :property, name: 'p'
    @q = create :property, name: 'q'
    @r = create :property, name: 'r'

    @s = create :space, name: 's'

    Trait.assert! @s, @p, description: "-"
    Trait.assert! @s, @r, description: "-"
  end

  it "can create theorems via assertion" do
    t = Theorem.assert! "(p + q) | r => r", description: "-"

    expect( t.antecedent ).to be_a_kind_of Formula::Disjunction
    expect( t.consequent ).to eq Formula::Atom.new @r, Value.true
  end

  [
    "p => ",
    "p => ) +",
    "p + () => q"
  ].each do |f|
    it "fails to create theorems from unparseable formulae (#{f})" do
      expect{ Theorem.assert! f, description: "-" }.to raise_error Formula::ParseError
    end
  end

  it "fails to create theorems with known counterexamples" do
    expect{ Theorem.assert! "p => ~r", description: "-" }.to(
      raise_error ActiveRecord::RecordInvalid, /counterexample/i)
  end
end

describe "Chained deduction", :job do
  before :all do
    @p = create :property, name: "p"
    @q = create :property, name: "q"
    @r = create :property, name: "r"
    @s = create :property, name: "s"

    @t = create :space, name: "t"
    @u = create :space, name: "u"

    Trait.assert! @t, @p, description: "-"
    Trait.assert! @t, @r, description: "-"

    Theorem.assert! "q + r => s", description: "-"
    Theorem.assert! "p => q", description: "-"

    Trait.assert! @u, @p, description: "-"
    Trait.assert! @u, @s, value: Value.false, description: "-"

    @st = @t.traits.where(property: @s).first!
    @ru = @u.traits.where(property: @r).first!
  end

  it "deduced the right value" do
    expect( @st.value ).to eq Value.true
  end

  it "knows its assumptions" do
    q, r = [@q, @r].map { |p| @t.traits.where(property: p).first! }
    expect( @st.proof.steps ).to eq [q, r, Theorem.first]
  end

  it "knows its supporters" do
    traits = [@p, @r].map { |p| @t.traits.where(property: p).first! }
    expect( @st.supporters.map &:assumed ).to eq traits
  end

  it "can follow contrapositives" do
    expect( @ru.value ).to eq Value.false
  end
end
