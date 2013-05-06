require 'spec_helper'

# FIXME: These are really trait post-save / integration specs
# FIXME: Check entire table against Counterexamples
describe Space do
  # The Space class needs to be lazy-loaded before we can reopen it
  class Space
    def << atom
      traits.create! property: atom.property, value: atom.value, description: 'Test'
    end
  end

  subject { FactoryGirl.create :space }
  before(:each) { theorem.save! validate: false }

  [:a, :b, :c].each do |sym|
    let(sym) { FactoryGirl.create(:property, name: sym).atom }
  end

  context 'simple implications' do
    let(:theorem) { a >> b }

    it 'checks directly' do
      subject << a
      expect( subject ).to satisfy b
    end

    it 'checks the contrapositive' do
      subject << ~b
      expect( subject ).to satisfy ~a
    end
  end

  context 'disjunctions' do
    let(:theorem) { a >> (b | c ) }

    it 'checks directly' do
      subject << a
      subject << ~c
      expect( subject ).to satisfy b
    end

    it 'checks the contrapositive' do
      subject << ~b
      subject << ~c
      expect( subject ).to satisfy ~a
    end

    it 'only forces disjunctions when known' do
      subject << a
      expect( subject ).not_to satisfy b
    end
  end

  context 'conjunctions' do
    let(:theorem) { a >> (b + c) }

    it 'checks directly' do
      subject << a
      expect( subject ).to satisfy (b + c)
    end

    it 'checks the contrapositive' do
      subject << ~c
      expect( subject ).to satisfy ~a
    end
  end
end
