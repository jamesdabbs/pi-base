require 'csv'

class Trait
  class Table
    attr_reader :spaces, :properties

    def initialize spaces=nil, properties=nil
      @spaces     = spaces     || Space.all.select(:id, :name)
      @properties = properties || Property.all.select(:id, :name)
    end

    def value_map
      @value_map ||= Hash[ Value.all.map { |v| [v.id, v.to_i] } ]
    end

    def traits
      @traits ||= begin
        Trait.
          where(space_id: spaces.pluck(:id), property_id: properties.pluck(:id)).
          order(:space_id)
      end
    end

    def trait_map
      return @trait_map if @trait_map
      @trait_map = Hash[ spaces.map { |s| [s.id, {}] } ]
      traits.each do |t|
        @trait_map[t.space_id][t.property_id] ||= [t.id, value_map[t.value_id]]
      end
      @trait_map
    end

    def link_trait v
      return "" unless v
      klass = v[1] == 1 ? "true" : "false"
      sym   = v[1] == 1 ? "✓"    : "⨯"
      "<a href='/traits/#{v[0]}' class='#{klass}'>#{sym}</a>"
    end

    def aaData
      spaces.map do |s|
        ["<a href='/spaces/#{s.id}'>#{s.name}</a>"] + properties.map { |p| link_trait trait_map[s.id][p.id] }
      end
    end

    class Checker < Table
      attr_reader :skips

      def read_csv! path=nil
        @csv = CSV.read Rails.root.join(path || 'counterexamples.csv')

        @maps = {
          properties: Hash[ @csv[2].each_with_index.map { |c,i| [c.to_i, i] } ],
          spaces:     Hash[ @csv.each_with_index.map { |r,i| [r[2].to_i, i] } ]
        }
        @skips = {}
      end

      def value_map
        { "0" => "False", "1" => "True" }
      end

      [:spaces, :properties].each do |klass|
        define_method klass do
          objs, @skips[klass] = super().partition { |o| @maps[klass][o.id] }
          objs.map &:id
        end
      end

      def traits
        Trait.
          where(space_id: spaces, property_id: properties).
          order(:space_id).
          includes(:value)
      end

      def positions
        traits.map do |t|
          row = @maps[:spaces][t.space_id]
          col = @maps[:properties][t.property_id]
          [t, [row, col]]
        end.compact
      end

      def check
        read_csv!

        positions.map do |t, (row, col)|
          next unless row && col
          expected = value_map[ @csv[row][col] ]
          if expected && t.value.name != expected
            [t, expected]
          end
        end.compact
      end
    end
  end

end