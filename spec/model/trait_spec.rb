require 'spec_helper'

describe Trait do
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
