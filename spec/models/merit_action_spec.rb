require 'spec_helper'

describe MeritAction do


  describe 'check_point_rules' do

    before  do
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

    describe 'when no rules apply' do
      let(:user) { User.create }
      let(:merit_action) { create :merit_action,
                                  :user_id => user.id,
                                  :target_model => "foos",
                                  :action_method => "index"}
      before do
        merit_action.check_point_rules
        user.reload
      end
      it { user.points.should == 0 }
    end

    describe 'when a rule does apply' do
      let(:user) { User.create }
      let(:merit_action) { create :merit_action,
                                  :user_id => user.id,
                                  :target_model => "foos",
                                  :action_method => "show"}
      before do
        merit_action.check_point_rules
        user.reload
      end
      it { user.points.should == 1 }
    end


  end

end
