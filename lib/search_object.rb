module SearchObject
  def self.included base
    base.send :include, Tire::Model::Search
    base.send :include, Tire::Model::Callbacks

    base.index_name "full"

    base.serialize :meta, JSON

    def to_indexed_json
      as_json.tap do |h|
        meta = h.delete 'meta'
        h.merge! meta if meta
      end.to_json
    end
  end
end
