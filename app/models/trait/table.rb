class Trait
  class Table
    attr_reader :spaces, :properties

    def initialize spaces=nil, properties=nil
      @spaces     = spaces     || Space.all.select(:id, :name)
      @properties = properties || Property.all.select(:id, :name)
    end

    def traits
      values = Hash[ Value.all.map { |v| [v.id, v.to_i] } ]
      result = Hash[ spaces.map    { |s| [s.id, {}    ] } ]
      Trait.select(:id, :space_id, :property_id, :value_id).each do |t|
        result[t.space_id][t.property_id] ||= [t.id, values[t.value_id]]
      end
      result
    end

    def to_json
      {
        spaces:     spaces,
        properties: properties,
        traits:     traits
      }.to_json
    end
  end
end