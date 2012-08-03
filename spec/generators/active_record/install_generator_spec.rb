require 'spec_helper'
require 'generators/active_record/install_generator'

describe ActiveRecord::Generators::InstallGenerator do

  # Tell the generator where to put its output (what it thinks of as Rails.root)
  destination File.expand_path("../../../tmp", __FILE__)

  before { prepare_destination }

  describe 'no arguments' do
    before { run_generator }

    describe 'create_merit_actions.rb' do
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
