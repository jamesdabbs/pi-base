ENV['ELASTICSEARCH_URL'] = ENV['BONSAI_URL']

Elasticsearch::Model.client = Elasticsearch::Client.new host: ENV['ELASTICSEARCH_URL']
