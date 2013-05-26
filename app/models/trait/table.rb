require 'csv'

class Trait
  class Table
    attr_reader :spaces, :properties

    def initialize spaces=nil, properties=nil
      @spaces     = spaces     || Space.all.select(:id, :name)
      @properties = properties || Property.all.select(:id, :name)
    end

    def traits
      return @traits if @traits
      values = Hash[ Value.all.map { |v| [v.id, v.to_i] } ]
      result = Hash[ spaces.map    { |s| [s.id, {}    ] } ]
      Trait.
        where(space_id: spaces.pluck(:id), property_id: properties.pluck(:id)).
        select(:id, :space_id, :property_id, :value_id).each do |t|
          result[t.space_id][t.property_id] ||= [t.id, values[t.value_id]]
      end
      @traits = result
    end

    def link_trait v
      return "" unless v
      klass = v[1] == 1 ? "true" : "false"
      sym   = v[1] == 1 ? "✓"    : "⨯"
      "<a href='/traits/#{v[0]}' class='#{klass}'>#{sym}</a>"
    end

    def aaData
      spaces.map do |s|
        ["<a href='/spaces/#{s.id}'>#{s.name}</a>"] + properties.map { |p| link_trait traits[s.id][p.id] }
      end
    end

    # -- Checking against Counterexamples -----
    def read_csv! path=nil
      @csv = CSV.read Rails.root.join(path || 'counterexamples.csv')

      @property_map = Hash[ @csv[2].each_with_index.map { |c,i| [c.to_i, i] } ]
      @space_map    = Hash[ @csv.each_with_index.map { |r,i| [r[2].to_i, i] } ]
    end

    def value_map
      value_map = { "0" => "False", "1" => "True" }
    end

    def traits_to_check
      sids, pids = [], []
      @skips = {}
      spaces.each     { |s| @space_map[s.id]    ? sids << s.id : @skips[s.name] = 1 }
      properties.each { |p| @property_map[p.id] ? pids << p.id : @skips[p.name] = 1 }

      Trait.where space_id: sids, property_id: pids
    end

    def check
      read_csv!

      traits_to_check.order(:space_id).includes(:space, :property, :value).map do |t|
        row = @space_map[t.space_id]
        col = @property_map[t.property_id]
        next unless row && col
        expected = value_map[ @csv[row][col] ]
        if expected && t.value.name != expected
          [t.space.name, t.name, expected]
          t.id
        end
      end.compact
    end

    def skipped
      @skips.keys
    end

  end
end