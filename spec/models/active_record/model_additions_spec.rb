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


  describe '#create_sash_if_none' do
    describe 'when no sash exists' do
      let(:user) { User.create }
      before { user.create_sash_if_none }
      it { user.sash.should_not be_nil }
      it { user.sash.sashable.should == user }
    end

    describe 'when a sash already exist' do
      let(:user) { User.create }
      before do
        user.create_sash_if_none
        @first_sash = user.sash
        user.create_sash_if_none
      end
      it { user.sash.should == @first_sash }
    end
  end

end
