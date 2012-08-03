# encoding: utf-8
$LOAD_PATH << "." unless $LOAD_PATH.include?(".")
begin
  require "rubygems"
  require "bundler"

  if Gem::Version.new(Bundler::VERSION) <= Gem::Version.new("0.9.5")
    raise RuntimeError, "Your bundler version is too old." +
      "Run `gem install bundler` to upgrade."
  end

  # Set up load paths for all bundled gems
  Bundler.setup
rescue Bundler::GemNotFound
  raise RuntimeError, "Bundler couldn't find some gems." +
    "Did you run \`bundlee install\`?"
end
Bundler.require

require 'ammeter/init'


# These models have their tables cleaned during clean_database!
def test_models
  []
end

# These tables are created during the migrations and are deleted if
# they are present during the initial setup
def migration_tables
  [ :sashes, :badges_sashes, :merit_actions, :awarded_points ]
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

require 'db_helper'
clean_database!

module TestApp
  class Application < Rails::Application
    config.root = File.expand_path "../../tmp/app/", __FILE__
  end
end
