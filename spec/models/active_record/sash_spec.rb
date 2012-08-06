require 'spec_helper'

require 'lib/merit/models/active_record/sash'
require 'lib/merit/models/active_record/awarded_point'

describe Sash do

  let(:sash) { Sash.create }
  subject { sash }

  describe '#awarded_points' do
    describe 'defaults to empty' do
      subject { sash.awarded_points }
      it { should == [] }
    end
  end

  describe "#badges" do
    subject { sash.badges }
    it { should be_empty }
  end

  describe 'total_points' do

    describe 'defaults' do
      its(:total_points) { should == 0 }
    end

    describe 'when added' do
      before do
        sash.awarded_points.create :points => 10
        sash.reload
      end
      its(:total_points) { should == 10 }
    end
  end

end
