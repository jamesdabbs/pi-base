FactoryGirl.define do
  factory :space do
    name        'Space'
    description 'Description'
  end

  factory :property do
    name        'Property'
    description 'Description'
    value_set   { ValueSet.boolean }
  end
end
