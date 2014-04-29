RSpec::Matchers.define :satisfy do |formula|
  match do |space|
    !!formula.verify(space)
  end

  failure_message do |space|
    "#{space.name} should satisfy #{formula}"
  end

  failure_message_when_negated do |space|
    "#{space.name} should not satisfy #{formula}"
  end
end


RSpec.configure do |config|
  helpers = Module.new do
    def atoms *syms
      syms.each { |sym| let(sym) { FactoryGirl.create(:property, name: sym).atom } }
    end

    def spaces *syms
      syms.each { |sym| let(sym) { FactoryGirl.create :space, name: sym } }
    end

    def assert! space, atom
      Trait.assert! space, atom.property, value: atom.value, description: "-"
    end
  end
  config.extend helpers
  config.include helpers

  # Need to make sure these exist to that e.g. formulae can deserialize them
  config.before :all do
    Value.true.save!
    Value.false.save!
  end
end
