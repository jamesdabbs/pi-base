require 'csv'

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

    def check
      csv = CSV.read Rails.root.join 'counterexamples.csv'
      space_map    = Hash[ csv.each_with_index.map { |r,i| [r[0], i] } ]
      property_map = Hash[ csv.first.each_with_index.map { |c,i| [c, i] } ]
      value_map    = { "0" => "False", "1" => "True" }

      space_ids    = @spaces.map &:id
      property_ids = @properties.map &:id
      traits = Trait.
        where(space_id: space_ids, property_id: property_ids).
        includes(:space, :property, :value).
        order(:space_id)

      traits.each do |t|
        # Look up trait value in table and check
        row = space_map[t.space.name]
        col = property_map[t.property.name]
        next unless row && col
        csv_val  = csv[row][col]
        expected = value_map[csv_val]
        if expected && t.value.name != expected
          puts "#{t.space.name} has #{t.property.name} #{t.value.name}, expected #{expected}"
        end
      end
      nil
    end
  end
end