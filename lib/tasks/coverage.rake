namespace :spec do
  desc 'Create rspec coverage'
  task :coverage do
    ENV['COVERAGE'] = 'true'
    Rake::Task['spec'].execute
  end
end