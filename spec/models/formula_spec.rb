require 'spec_helper'

describe Formula do
  before :each do
    @p1 = create :property, name: '1'
    @p2 = create :property, name: '2'

    s1 = create :space
    s2 = create :space
    s3 = create :space

    boolean = ValueSet.where(name: 'boolean').first_or_create!

    @t = create :value, name: 'True',  value_set: boolean
    @f = create :value, name: 'False', value_set: boolean

    {
      s1 => [@t, @t],
      s2 => [@t, @f],
      s3 => [@f, @f]
    }.each do |s, vs|
      create :trait, space: s, property: @p1, value: vs[0]
      create :trait, space: s, property: @p2, value: vs[1]
    end
  end

  let(:a1t) { Formula::Atom.new @p1, @t }
  let(:a1f) { Formula::Atom.new @p1, @f }
  let(:a2t) { Formula::Atom.new @p2, @t }
  let(:a2f) { Formula::Atom.new @p2, @f }

  it 'looks up spaces' do
    a1t.spaces.should have(2).members
    a1t.spaces(false).should have(1).member
    a1t.spaces(nil).should be_empty

    a1f.spaces.should have(1).member
    a1f.spaces(false).should have(2).members
    a1f.spaces(nil).should be_empty
  end

  it 'conjunts correctly' do
    (a1t + a1f).spaces.should be_empty
    (a1t + a2f).spaces.should have(1).member
  end

  it 'disjuncts correctly' do
    (a1t | a1f).spaces.should have(3).members
    (a1f | a2t).spaces.should have(2).members
  end

  it 'handles complicated formulae' do
    f = (a1t + a2f) | a1f
    f.spaces.should have(2).members
    f.spaces(false).should have(1).member
  end

  it 'can parse subformulae' do
    f = Formula.parse '(a | b) + ((c + d) | e) + f'
    f.should be_an_instance_of Formula::Conjunction
    f.subformulae.should have(3).members

    sf = f.subformulae[1]
    sf.should be_an_instance_of Formula::Disjunction
    sf.subformulae.should have(2).members
  end

  pending 'handles e.g. "(\\(T_1\\) = True + Normal = True)"'
end