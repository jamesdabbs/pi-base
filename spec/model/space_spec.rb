require 'spec_helper'

# TODO: Check entire table against Counterexamples
describe Space do
  let(:a) { FactoryGirl.create(:property, name: :a).atom }

  [:s, :t].each do |sym|
    let(sym) { FactoryGirl.create :space, name: sym }
  end

  before(:each) do
    s <<  a
    t << ~a
  end

  it 'can look up by formula' do
    expect( Space.by_formula a => true ).to eq [s]
  end

  it 'can find spaces where a formula is false' do
    expect( Space.by_formula a => false ).to eq [t]
  end
end
