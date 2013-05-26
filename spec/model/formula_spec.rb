require 'spec_helper'

def Formula.ld str
  Formula.dump Formula.load str
end

describe Formula do
  atoms :a, :b, :c, :d, :e

  let :f do
    FactoryGirl.create(:property, name: 'Escaped $\sigma$-math').atom
  end

  def preserves f
    d   = Formula.dump f
    dld = Formula.dump Formula.load d
    expect( d ).to eq dld
  end

  it { preserves a + b                 }
  it { preserves a | b                 }
  it { preserves a + (b | c)           }
  it { preserves a | (b + c + (d | e)) }
  it { preserves d | (e + f)           }
end