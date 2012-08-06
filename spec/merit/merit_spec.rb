require 'spec_helper'

describe Merit do

  describe 'without having merit' do
    before do
      Object.send(:remove_const, :FakeModel) if defined? FakeModel
      class FakeModel < ActiveRecord::Base
        self.table_name = "users"
      end
    end
    subject { FakeModel }
    its(:has_merit?) { should == false }

    describe 'instances without merit' do
      subject { FakeModel.new }
      it { should_not respond_to :award_points }
    end
  end

  describe 'with having merit' do
    before do
      Object.send(:remove_const, :FakeModel) if defined? FakeModel
      class FakeModel < ActiveRecord::Base
        self.table_name = "users"
        has_merit
      end
    end
    subject { FakeModel }
    its(:has_merit?) { should == true }

    describe 'instances created' do
      subject { FakeModel.new }
      it { should respond_to :award_points }
    end
  end

end
