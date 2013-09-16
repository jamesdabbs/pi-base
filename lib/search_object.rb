module SearchObject
  def self.included base
    base.send :include, Tire::Model::Search
    base.send :include, Tire::Model::Callbacks

    base.index_name "full"

    base.serialize :meta, JSON

    def to_indexed_json
      h = as_json
      h.merge(h.delete 'meta').to_json
    end
  end
end
