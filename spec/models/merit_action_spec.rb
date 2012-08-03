require 'spec_helper'

describe MeritAction do


  describe 'actions_to_point' do
    before do
      Merit.send(:remove_const, :PointRules) if defined? Merit::PointRules
      module Merit
        class PointRules
          include Merit::PointRulesMethods
          def initialize
            score 1, :on => "foos#show"
          end
        end
      end
    end

    subject { merit_action.actions_to_point }

    describe 'when there are points for the action' do
      let(:merit_action) { create :merit_action, :target_model => 'foos', :action_method => "show" }
      its(:count) { should == 1 }
    end

    describe 'when there are no points for the action' do
      let(:merit_action) { create :merit_action, :target_model => 'foos', :action_method => "index" }
      its(:count) { should == 0 }
    end
  end


  describe 'check_point_rules' do

    let(:user) { User.create }
    let(:user) { User.create }
    let(:merit_action) { create :merit_action, :user_id => user.id }

    describe 'when no rules apply' do
      before  do
        MeritAction.any_instance.stub :actions_to_point => [ ]
      end
      before do
        merit_action.check_point_rules
        user.reload
      end
      it { user.points.should == 0 }
    end

    describe 'when a rule does apply' do
      describe 'to :action_user' do
        before  do
          MeritAction.any_instance.stub :actions_to_point => [ { :to => [:action_user], :score => 1 } ]
        end
        before do
          merit_action.check_point_rules
          user.reload
        end
        it { user.sash.awarded_points.size.should == 1 }
        it { user.sash.awarded_points.first.points.should == 1 }
        it { user.points.should == 1 }
      end
    end

  end

end
