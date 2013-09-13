# FIXME: refactor so that this only requires spec_helper_min
require 'spec_helper'

def Formula.ld str
  Formula.dump Formula.load str
end

describe Formula do
  atoms :a, :b, :c, :d, :e

  let :f do
    FactoryGirl.create(:property, name: 'Escaped $\sigma$-math').atom
  end

  def standardize str
    Formula.dump Formula.load str
  end

  def preserves f
    d = Formula.dump f
    expect( d ).to eq standardize d
  end

  it { preserves a + b                 }
  it { preserves a | b                 }
  it { preserves a + (b | c)           }
  it { preserves a | (b + c + (d | e)) }
  it { preserves d | (e + f)           }

  context 'condensed syntax parsing' do

    # Need to refer to these so that they are created
    before(:each) { a; b; c; }

    {
      ' ( a +   b) |  c' => '((a = True + b = True) | c = True)',
      ' (~a | ~ b) + ~c' => '((a = False | b = False) + c = False)',
      '~( a +   b)'      => '(a = False | b = False)'
    }.each do |shorthand, standard|
      it "parses '#{shorthand}'" do
        expect( standardize shorthand ).to eq standard
      end
    end
  end
end