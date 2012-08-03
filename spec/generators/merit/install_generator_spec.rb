require 'spec_helper'
require 'generators/merit/install_generator'
require 'generators/active_record/install_generator'

describe Merit::Generators::InstallGenerator do

  # Tell the generator where to put its output (what it thinks of as Rails.root)
  destination File.expand_path "../../../tmp", __FILE__


  describe 'with ActiveRecord' do

    before do
      ::Rails::Generators.options[:rails][:orm] = :active_record
      prepare_destination
    end

    describe 'no arguments' do
      before { run_generator }

      describe 'initializer' do
        subject { file 'config/initializers/merit.rb' }
        it { should exist }
        it { should contain /Merit.setup do |config|/ }
      end

      describe 'badge rules' do
        subject { file 'app/models/merit/badge_rules.rb' }
        it { should exist }
      end

      describe 'point rules' do
        subject { file 'app/models/merit/point_rules.rb' }
        it { should exist }
      end

      describe 'rank rules' do
        subject { file 'app/models/merit/rank_rules.rb' }
        it { should exist }
      end

      describe 'create_merit_actions' do
        subject { file('db/migrate/create_merit_actions.rb') }
        it { should be_a_migration }
      end
      describe 'create_sashes.rb' do
        subject { file('db/migrate/create_sashes.rb') }
        it { should be_a_migration }
      end
      describe 'create_badges_sashes.rb' do
        subject { file('db/migrate/create_badges_sashes.rb') }
        it { should be_a_migration }
      end

    end

  end
end
