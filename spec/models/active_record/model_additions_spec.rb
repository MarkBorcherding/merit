require 'spec_helper'

describe 'Merit model additions' do

  describe '#award_points' do
    let(:user) { User.create }

    describe 'without a category' do
      before { user.award_points 10 }
      subject { user.sash.awarded_points.last }
      its(:points) { should == 10 }
      its(:category) { should be_nil }
    end

    describe 'with a category' do
      before { user.award_points 10, :in => "strength" }
      subject { user.sash.awarded_points.last }
      its(:points) { should == 10 }
      its(:category) { should == "strength" }
    end
  end

  describe "lazy sash creation" do
    let(:user) { User.create }
    subject { user.sash }
    it { should_not be_nil }
  end

end
