require 'spec_helper'

describe Merit::PointRulesMethods do


  describe "before adding points " do
    class PointRules
      include Merit::PointRulesMethods
    end

    subject { PointRules.new }
    its(:actions_to_point) { should be_empty }
  end

  describe "adding points" do

    class PointRules2
      include Merit::PointRulesMethods
      def initialize
        score 10, :on => "users#create"
        score 11, :on => ["foos#create", "foos#update"]
        score 12, :on => "bars#update", :to => :someone_else
        score 13, :on => "bars#create", :to => [:someone_else, :same_someone]
        score 14, :on => "bazs#update", :in => :strength
        score 15, :on => "bazs#show", :in => [:strength, :charisma]
        score 16, :on => 'foo#show', :to => :someone
        score 17, :on => 'foo#show', :to => :someone_else
      end
    end
    let(:actions) { PointRules2.new.actions_to_point }
    it { actions.should_not be_empty }

    describe "Simple point rules" do
      subject { actions["users#create"].first }
      it { subject[:score].should == 10 }
      it { subject[:to].should == [:action_user] }
    end

    describe "multiple actions rule" do
      subject { actions }
      ["foos#create", "foos#update"].each do |action|
        it { actions[action].first[:score].should == 11 }
        it { actions[action].first[:to].should == [:action_user] }
      end
    end

    describe "other target rules" do
      subject { actions["bars#update"].first }
      it { subject[:score].should == 12 }
      it { subject[:to].should == [:someone_else] }
    end

    describe "multiple other target rules" do
      subject { actions["bars#create"].first }
      it { subject[:score].should == 13 }
      it { subject[:to].should == [:someone_else, :same_someone] }
    end

    describe "rule with point category" do
      subject { actions["bazs#update"].first }
      it { subject[:score].should == 14 }
      it { subject[:to].should == [:action_user] }
      it { subject[:in].should == [ :strength ] }
    end

    describe "rule with multiple point categories" do
      subject { actions["bazs#show"].first }
      it { subject[:score].should == 15 }
      it { subject[:to].should == [:action_user] }
      it { subject[:in].should == [:strength, :charisma] }
    end

    describe 'multiple points for the same actions' do
      subject { actions["foo#show"] }
      it { subject.map { |p| p[:score] }.should == [16,17] }
      it { subject.map { |p| p[:to] }.should == [[:someone],[:someone_else]] }
    end
  end


end
