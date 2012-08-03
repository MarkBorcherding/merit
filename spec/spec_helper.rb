# encoding: utf-8
$LOAD_PATH << "." unless $LOAD_PATH.include?(".")

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../dummy/config/environment', __FILE__)


# Run these migrations during setup the database. This lets us test the migrations as
# part of the specs
def migrations
  require 'generators/active_record/templates/create_merit_actions'
  require 'generators/active_record/templates/create_sashes'
  require 'generators/active_record/templates/create_badges_sashes'
  require 'generators/active_record/templates/create_awarded_points'
  require 'generators/active_record/templates/make_sash_polymorphic_back_to_target'
  [ CreateMeritActions,
    CreateSashes,
    CreateBadgesSashes,
    CreateAwardedPoints,
    MakeSashPolymorphic ]
end

def redo_migrations!
  begin
    ActiveRecord::Migration.verbose = false
    migrations.reverse.each { |m| m.down }
    migrations.each { |m| m.up }
  rescue ActiveRecord::StatementInvalid
  end
end
redo_migrations!


require 'ammeter/init'
