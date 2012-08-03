require 'spec_helper'

require 'lib/merit/models/active_record/sash'
require 'lib/merit/models/active_record/awarded_point'

describe Sash do

  describe '#awarded_points' do
    describe 'defaults to empty' do
      subject { Sash.new.awarded_points }
      it { should == [] }
    end
  end

end
