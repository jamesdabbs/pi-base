desc 'Import models into Elasticsearch'
task :import => :environment do
  [Space, Property, Theorem].each do |model|
    model.import
  end
end
