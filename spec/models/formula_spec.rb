require 'spec_helper'

describe Formula do
  before :each do
    @p1 = create :property
    @p2 = create :property

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

  let(:a1) { Formula::Atom.new @p1, @t }
  let(:a2) { Formula::Atom.new @p1, @f }

  it 'looks up spaces' do
    a1.spaces.should have(2).members
  end

  it 'looks up spaces' do
    a1.spaces(false).should have(1).members
  end

  it 'looks up spaces' do
    a1.spaces(nil).should be_empty
  end

  it 'conjunts correctly' do
    (a1 + a2).spaces.should be_empty
  end

  it 'disjuncts correctly' do
    (a1 | a2).spaces.should have(3).members
  end
end