module Search
  def self.client
    Elasticsearch::Client.new host: ENV['ELASTICSEARCH_URL'], logger: Rails.logger
  end

  def self.index_name; "pi-base-#{Rails.env}"; end

  def self.default_opts
    { index: index_name }
  end

  def self.index opts;  client.index opts.merge default_opts;  end
  def self.delete opts; client.delete opts.merge default_opts; end

  # This is rather hacky mocking so that the pagination of results works
  # consistently with models. TODO: move to kaminari?
  class Query
    def initialize q
      @q, @page, @per_page = q, 1, 30
    end

    def paginate page: 1, per_page: 30
      @page     = page.to_i if page
      @per_page = per_page.to_i if per_page
      data = Search.client.search(
        index: Search.index_name,
        from:  (@page-1)*@per_page,
        size:  @per_page,
        q:     @q
      )
      Results.new data, @page, @per_page
    end
  end

  class Results
    include Enumerable

    attr_reader :count, :total_pages, :current_page

    def initialize data, current_page, size
      @current_page, @size = current_page, size
      @total = data["hits"]["total"]
      @total_pages = (@total / @size.to_f).ceil

      lookup = {}
      to_fetch = data["hits"]["hits"].group_by { |h| h["_type"] }
      to_fetch.each do |klass, hs|
        ids = hs.map { |h| h["_id"].to_i }
        klass.constantize.where(id: ids).each { |o| lookup[[klass,o.id]] = o }
      end
      @hits = data["hits"]["hits"].map { |h| lookup[[h["_type"],h["_id"].to_i]] }.compact
    end

    def each &block
      @hits.each &block
    end
  end

  def self.query q
    Query.new q
  end

  def indexed?; true; end

  def as_indexed_json
    { name: name, description: description }
  end

  extend ActiveSupport::Concern

  included do
    #include Elasticsearch::Model

    #after_commit on: [:create] do
    #  IndexJob.new.async.perform :create, self.class.name, id
    #end

    #after_commit on: [:update] do
    #  IndexJob.new.async.perform :update, self.class.name, id
    #end

    #after_commit on: [:destroy] do
    #  IndexJob.new.async.perform :delete, self.class.name, id
    #end
  end
end
