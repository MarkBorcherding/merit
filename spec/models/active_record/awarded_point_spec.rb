require 'spec_helper'
require 'lib/merit/models/active_record/awarded_point'

describe AwardedPoint do

  describe 'scopes' do

    describe 'in a category' do
      let(:sash) { Sash.create }
      before do
        [ :strength, :strength, :strength,
          :charisma, :charisma,
          :dexterity
        ].each do |c|
          sash.awarded_points.create :points => 5, :category => c
        end
      end

      describe 'when there are points in the category' do
        subject { AwardedPoint.in(:strength) }
        it { should have(3).points }
        it { subject.all?{ |c| c.category == "strength" }.should == true }
      end

      describe 'when there are not points in the category' do
        subject { AwardedPoint.in(:constitution) }
        it { should have(0).points }
        it { subject.all?{ |c| c.category == "strength" }.should == true }
      end
    end

  end

end
