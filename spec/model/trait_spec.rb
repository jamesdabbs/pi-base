require 'spec_helper'

describe Trait, :job do
  subject { create :space }
  before(:each) do
    [Theorem, Trait].map &:delete_all
    theorem.save! validate: false
  end

  atoms :a, :b, :c

  context 'simple implications' do
    let(:theorem) { a >> b }

    it 'checks directly' do
      assert! subject, a
      expect( subject ).to satisfy b
    end

    it 'checks the contrapositive' do
      assert! subject, ~b
      expect( subject ).to satisfy ~a
    end
  end

  context 'disjunctions' do
    let(:theorem) { a >> (b | c ) }

    it 'checks directly' do
      assert! subject, a
      assert! subject, ~c
      expect( subject ).to satisfy b
    end

    it 'checks the contrapositive' do
      assert! subject, ~b
      assert! subject, ~c
      expect( subject ).to satisfy ~a
    end

    it 'only forces disjunctions when known' do
      assert! subject, a
      expect( subject ).not_to satisfy b
    end
  end

  context 'conjunctions' do
    let(:theorem) { a >> (b + c) }

    it 'checks directly' do
      assert! subject, a
      expect( subject ).to satisfy (b + c)
    end

    it 'checks the contrapositive' do
      assert! subject, ~c
      expect( subject ).to satisfy ~a
    end
  end
end
