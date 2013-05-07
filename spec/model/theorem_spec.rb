require 'spec_helper'

describe Theorem do
  atoms :a, :b
  spaces :s

  before(:each) do
    s << a
    s << ~b
  end

  it 'does not allow a disprovable theorem to be added' do
    theorem = a >> b
    theorem.description = '-'
    expect { theorem.save! }.to raise_error ActiveRecord::RecordInvalid, /counterexample/i
  end
end