# encoding: utf-8
$LOAD_PATH << "." unless $LOAD_PATH.include?(".")

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../dummy/config/environment', __FILE__)

# These tables are created during the migrations and are deleted if
# they are present during the initial setup
def delete_migration_tables
  [ :sashes, :badges_sashes, :merit_actions, :awarded_points ].each do |t|
    begin
      ActiveRecord::Base.connection.execute "DROP TABLE #{t}"
    rescue ActiveRecord::StatementInvalid
    end
  end
end

# Run these migrations during setup the database. This lets us test the migrations as
# part of the
def migrations
  require 'generators/active_record/templates/create_merit_actions'
  require 'generators/active_record/templates/create_sashes'
  require 'generators/active_record/templates/create_badges_sashes'
  require 'generators/active_record/templates/create_awarded_points'
  [ CreateMeritActions, CreateSashes, CreateBadgesSashes, CreateAwardedPoints ]
end

def redo_migrations
  delete_migration_tables
  migrations.each { |m| m.up }
end

require 'ammeter/init'
