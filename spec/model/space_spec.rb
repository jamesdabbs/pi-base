require 'spec_helper'

def create_trait space, atom
  space.traits.create! property: atom.property, value: atom.value, description: 'Test'
end

describe Space do
  subject { FactoryGirl.create :space }
  before(:each) { theorem.save! validate: false }

  [:a, :b, :c].each do |sym|
    let(sym) { FactoryGirl.create(:property, name: sym).atom }
  end

  context 'simple implications' do
    let(:theorem) { a >> b }

    it 'generates implied traits' do
      create_trait subject, a
      expect( subject ).to satisfy b
    end

    it 'checks the contrapositive' do
      create_trait subject, ~b
      expect( subject ).to satisfy a
    end
  end

  context 'compound implications' do
    let(:theorem) { a >> (b | c ) }

    it 'can force disjunctions' do
      create_trait subject, a
      create_trait subject, ~c
      expect( subject ).to satisfy b
    end

    it 'only forces disjunctions when known' do
      create_trait subject, a
      expect( subject ).not_to satisfy b
    end
  end
end