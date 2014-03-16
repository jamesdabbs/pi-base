require 'spec_helper'

# TODO: Check entire table against Counterexamples
describe Space do
  atoms  :a
  spaces :s, :t

  before(:each) do
    assert! s, a
    assert! t, ~a
  end

  it 'can look up by formula' do
    expect( Space.by_formula a => true ).to eq [s]
  end

  it 'can find spaces where a formula is false' do
    expect( Space.by_formula a => false ).to eq [t]
  end
end
