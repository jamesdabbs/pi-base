ENV['ELASTICSEARCH_URL'] = ENV['BONSAI_URL']

Elasticsearch::Model.client = Search.client
