# -*- mode: ruby -*-
# vi: set ft=ruby :

require "open3"

class Legacy < Thor

  desc "import", "Port data from a legacy database"
  method_option :pry,
    aliases: "-p",
    type:    :boolean,
    desc:    "Drop to a pry prompt after importing"
  method_option :env,
    aliases: "-e",
    type:    :string,
    default: "legacy",
    desc:    "Database environment (in database.yml) to import from"
  default_task def import
    boot!
    raise "This command should only be run in development" unless Rails.env.development?

    Importer.new(connect options[:env]).run!

    binding.pry if options[:pry]

  rescue Sequel::DatabaseConnectionError
    say "Cannot connect to database - Please make sure it has been loaded", :red
  end


  no_tasks do

    def db_config env
      YAML.load_file(File.expand_path "../../../config/database.yml", __FILE__).fetch env
    end

    def boot!
      require "sequel"

      print "Loading Rails environment ... "
      require File.expand_path "../../../config/environment", __FILE__
      puts "Done"

      Rails.logger = Logger.new STDOUT
    end

    def connect env
      db = db_config env
      addr = %{ #{db['adapter']}  ://
                #{db['username']} :
                #{db['password']} @
                #{db['host']}     :
                #{db['port']}     /
                #{db['database']} }.gsub /\s+/, ''
      Sequel.connect addr
    end

  end
end
