require 'active_record'
# set adapter to use, default is sqlite3
# to use an alternative adapter run => rake spec DB='postgresql'
db_name = ENV['DB'] || 'sqlite3'
database_yml = File.expand_path('../database.yml', __FILE__)

def drop_migration_tables!
  migration_tables.each do |table_name|
    begin
      ActiveRecord::Base.connection.execute "DROP TABLE #{table_name}"
    rescue ActiveRecord::StatementInvalid
    end
  end
end

def clean_database!
  test_models.each do |model|
    ActiveRecord::Base.connection.execute "DELETE FROM #{model.table_name}"
  end
end

if File.exists?(database_yml)
  active_record_configuration = YAML.load_file(database_yml)

  ActiveRecord::Base.configurations = active_record_configuration
  config = ActiveRecord::Base.configurations[db_name]

  begin
    ActiveRecord::Base.establish_connection(db_name)
    ActiveRecord::Base.connection
  rescue SQLite3::CantOpenException
    db_dir = File.dirname(File.expand_path(config["database"]))
    FileUtils.mkdir_p db_dir
    ActiveRecord::Base.establish_connection(db_name)
    ActiveRecord::Base.connection
  rescue
    ActiveRecord::Base.establish_connection(config)
  end

  ActiveRecord::Base.logger = Logger.new(File.join(File.dirname(__FILE__), "debug.log"))
  ActiveRecord::Base.default_timezone = :utc

  ActiveRecord::Base.silence do
    ActiveRecord::Migration.verbose = false
    load(File.dirname(__FILE__) + '/schema.rb')
    load(File.dirname(__FILE__) + '/models.rb')

    drop_migration_tables!
    migrations.each do |migration|
      migration.up
    end
  end

else
  raise "Please create #{database_yml} first to configure your database."
end



