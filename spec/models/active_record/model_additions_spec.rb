require 'spec_helper'

describe 'Merit model additions' do

  describe '#award_points' do
    let(:user) { User.create }
    before { user.award_points 10 }

    describe 'adds to the awarded_points collection' do
      subject { user.sash.awarded_points.last }
      its(:points) { should == 10 }
      its(:category) { should be_nil }
    end

  end

  describe "lazy sash creation" do
    let(:user) { User.create }
    subject { user.sash }
    it { should_not be_nil }
  end


end
