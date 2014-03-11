module Search
  def self.index_name
    "pi-base-#{Rails.env}"
  end

  def search q
    raise NotImpelemented
  end

  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    # FIXME: this guess doesn't work; track down some docs
    mapping index: { name: index_name } do
      indexes :name, analyzer: 'english'
      indexes :description, analyzer: 'english'
    end
  end
end
