require 'spec_helper'

def create_trait space, atom
  space.traits.create! property: atom.property, value: atom.value, description: 'Test'
end

describe Space do
  subject { FactoryGirl.create :space }

  context 'simple implications' do
    let(:a) { FactoryGirl.create(:property, name: 'A').atom }
    let(:b) { FactoryGirl.create(:property, name: 'B').atom }

    before(:each) { (a >> b).save! validate: false }

    it 'generates implied traits' do
      create_trait subject, a
      expect( subject ).to satisfy b
    end
  end
end