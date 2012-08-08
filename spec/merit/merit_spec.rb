require 'spec_helper'

describe Merit do

  describe 'without having merit' do
    before do
      Object.send(:remove_const, :FakeUserModel) if defined? FakeUserModel
      class FakeUserModel < ActiveRecord::Base
        self.table_name = "users"
      end
    end
    subject { FakeUserModel }
    its(:has_merit?) { should == false }

    describe 'instances without merit' do
      subject { FakeUserModel.new }
      it { should_not respond_to :award_points }
      it { subject.class.has_merit?.should == false }
      its(:has_merit?) { should == false }
    end
  end

  describe 'with having merit' do
    before do
      Object.send(:remove_const, :FakeUserModel) if defined? FakeUserModel
      class FakeUserModel < ActiveRecord::Base
        self.table_name = "users"
        has_merit
      end
    end

    subject { FakeUserModel }
    its(:has_merit?) { should == true }

    describe 'instances created' do
      subject { FakeUserModel.new }
      it { should respond_to :award_points }
    end

    describe 'points total' do

      let(:user) { FakeUserModel.create }
      subject { user }
      it { subject.class.has_merit?.should == true }

      describe 'defaults' do
        its(:total_points) { should == 0 }
        its(:points) { should == 0 }
      end

      describe 'increment when points are added' do
        before do
          user.sash.awarded_points.create :points => 10
          user.sash.reload
        end
        its(:total_points) { should == 10 }
        its(:points) { should == 10 }
      end

    end
  end

end
