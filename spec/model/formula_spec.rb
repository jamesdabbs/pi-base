require 'spec_helper'


describe Formula do
  atoms :a, :b, :c, :d, :e

  let :f do
    FactoryGirl.create(:property, name: 'Escaped $\sigma$-math').atom
  end

  def standardize str
    Formula.parse_text(str).to_s
  end

  def preserves f
    d = f.to_s
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
      ' ( a +   b) |  c' => '((a + b) | c)',
      ' (~a | ~ b) + ~c' => '((¬a | ¬b) + ¬c)',
      '~( a +   b)'      => '(¬a | ¬b)'
    }.each do |shorthand, standard|
      it "parses '#{shorthand}'" do
        expect( standardize shorthand ).to eq standard
      end
    end
  end
end
