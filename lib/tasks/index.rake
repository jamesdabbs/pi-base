desc 'Index fresh elasticsearch data'
task :index => :environment do
  [Space, Property, Theorem, Trait].each do |model|
    model.pluck(:id).each { |id| IndexJob.new.perform :create, model.name, id }
  end
end
